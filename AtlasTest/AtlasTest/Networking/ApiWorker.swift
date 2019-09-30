//
//  ApiWorker.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/30/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

// MARK: - Network request
enum NetworkRequestResult: Equatable {
    case error(appError: AppTestError)
    case response(result: Any)
    
    static func ==(lhs: NetworkRequestResult, rhs: NetworkRequestResult) -> Bool {
        switch (lhs, rhs) {
        case (let .error(appError: a1), let .error(appError: a2)):
            return a1.name == a2.name
        case (let .response(result: a1), let .response(result: a2)):
            return a1 as? AnyObject === a2 as? AnyObject
        default:
            return false
        }
    }
}

protocol ApiWorker {
    func login(username: String, password: String, completionHandler: @escaping ((NetworkRequestResult) -> Void))
    func getServers(completionHandler: @escaping ((NetworkRequestResult) -> Void))
}

final class ApiNetWorker: ApiWorker {
    private unowned var dependency: DependencyContainer
    private var apiManager: ApiManager
    
    init(dependency: DependencyContainer) {
        self.dependency = dependency
        self.apiManager = ApiAppManager(dependency: dependency)
    }
    
    func login(username: String, password: String, completionHandler: @escaping ((NetworkRequestResult) -> Void)) {
        apiManager.login(with: username, password: password) { json, data, error, httpResponse in
            do {
                if ErrorHandler.processedError?.severity == ErrorSeverity.fatal { return }
                if let receivedError = error {
                    completionHandler(.error(appError: AppTestError.errorWith(error: receivedError)))
                    return
                }
                guard let receivedData = data else { return }
                guard error == nil else {
                    completionHandler(.error(appError: AppTestError.service))
                    return
                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(Token.self, from: receivedData)
                completionHandler(.response(result: response.token))
                LocalStorage.saveUser(name: username, password: password)
            } catch {
                completionHandler(.error(appError: AppTestError.service))
            }
        }
    }
    
    func getServers(completionHandler: @escaping ((NetworkRequestResult) -> Void)) {
        apiManager.getServers() { json, data, error, httpResponse in
            do {
                if ErrorHandler.processedError?.severity == ErrorSeverity.fatal { return }
                if let receivedError = error {
                    completionHandler(.error(appError: AppTestError.errorWith(error: receivedError)))
                    return
                }
                guard let receivedData = data else { return }
                guard error == nil else {
                    completionHandler(.error(appError: AppTestError.service))
                    return
                }
                let decoder = JSONDecoder()
                let response = try decoder.decode([Server].self, from: receivedData)
                completionHandler(.response(result: response))
            } catch {
                completionHandler(.error(appError: AppTestError.service))
            }
        }
    }
}
