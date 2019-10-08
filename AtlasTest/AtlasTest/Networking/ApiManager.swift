//
//  ApiManager.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

typealias ServiceResponse = ([String: Any], Data?, AppError?, HTTPURLResponse?) -> Void

protocol ApiManager {
    func login(with username: String, password: String, onCompletion:@escaping ([String: Any], Data?, AppError?, HTTPURLResponse?) -> Void)
    func getServers(onCompletion:@escaping ([String: Any], Data?, AppError?, HTTPURLResponse?) -> Void)
}

final class ApiAppManager: ApiManager {
    private unowned var dependency: DependencyContainer
    
    init(dependency: DependencyContainer) {
        self.dependency = dependency
    }
    
    func login(with username: String, password: String, onCompletion:@escaping ([String: Any], Data?, AppError?, HTTPURLResponse?) -> Void) {
        guard let urlRequest = Api.getAccessToken(username: username, password: password).request() else {
            fatalError("Unable to build URLRequest")
        }
        perform(request: urlRequest, onCompletion: onCompletion)
    }
    
    func getServers(onCompletion:@escaping ([String: Any], Data?, AppError?, HTTPURLResponse?) -> Void) {
        guard let urlRequest = Api.getServers.request() else {
            fatalError("Unable to build URLRequest")
        }
        perform(request: urlRequest, onCompletion: onCompletion)
    }
}

private extension ApiAppManager {
    // MARK: - perform request
    func perform(request: URLRequest, onCompletion: @escaping ServiceResponse) {
        let config = URLSessionConfiguration.ephemeral
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForResource = 60.0

        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
        }
        let session = URLSession(
            configuration: config,
            delegate: nil,
            delegateQueue: nil)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                self?.onError(error: AppTestError.errorWith(error: error), request: request, onCompletion: onCompletion)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                self?.onError(error: AppTestError.service, request: request, onCompletion: onCompletion)
                return
            }
            if response.statusCode == 401 {
                self?.onError(error: AppTestError.authError, request: request, onCompletion: onCompletion)
                return
            }
            if response.statusCode == 400 {
                self?.onError(error: AppTestError.service, request: request, onCompletion: onCompletion)
                return
            }
            guard 200 ... 299 ~= response.statusCode else {
                self?.onError(error: AppTestError.service, request: request, onCompletion: onCompletion)
                return
            }
            var jsonData: [String: Any] = [:]
            if let receivedData = data {
                if let json = (try? JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                    jsonData = json
                }
            }
            var responseError: AppTestError? = nil
            if let error = error {
                responseError = error as? AppTestError ?? AppTestError.errorWith(error: error)
            }
            self?.processResponse(with: jsonData, data: data, urlResponse: response, error: responseError, onCompletion: onCompletion)
        }
        task.resume()
    }

    func processResponse(with jsonData: [String: Any]?, data: Data?, urlResponse: URLResponse?, error: AppTestError?, onCompletion:@escaping ServiceResponse) {
        DispatchQueue.main.async {
            onCompletion(jsonData ?? [:], data, error, urlResponse as? HTTPURLResponse)
        }
    }
    
    func onError(error: Error, request: URLRequest, onCompletion: @escaping ServiceResponse) {
        DispatchQueue.main.async {
            guard let error = error as? AppTestError else {
                return onCompletion([:], nil, AppTestError.service, nil)
            }
            switch error {
            case .errorWith(let error):
                onCompletion([:], nil, AppTestError.errorWith(error: error), nil)
            case .service: onCompletion([:], nil, AppTestError.service, nil)
            case .authError:
                return onCompletion([:], nil, AppTestError.authError, nil)
            default: onCompletion([:], nil, AppTestError.service, nil)
            }
        }
    }
}
