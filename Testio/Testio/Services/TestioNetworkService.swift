//
//  TestioNetworkService.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

private let TestioAPIURLStringFormat = "http://playground.tesonet.lt/v1/%@"

private enum TestioEndpoint: String {
    case tokens
    case servers
}

typealias AuthorizationHandler = (Result<TestioToken, TestioAPIError>) -> ()
typealias ServerRetrievalHandler = (Result<[TestioServer], TestioAPIError>) -> ()

protocol ServersRetrievingType {

    func servers(withToken token: TestioToken, handler: @escaping ServerRetrievalHandler)
    
}

protocol AuthorizationPerformingType {

    func authorize(user: TestioUser, handler: @escaping AuthorizationHandler)
    
}

class TestioNetworkService: AuthorizationPerformingType, ServersRetrievingType {

    private var acceptableStatusCodes: Range<Int> { return 200..<300 }
    
    func authorize(user: TestioUser, handler: @escaping AuthorizationHandler) {
        let endpointString = String.init(format: TestioAPIURLStringFormat, TestioEndpoint.tokens.rawValue)
        
        guard let encodedCredentials = try? user.encode(),
            let endpointURL = URL(string: endpointString) else {
            handler(.failure(.unknown(nil)))
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedCredentials

        performDataTask(withRequest: request, handler: handler)
    }
    
    func servers(withToken token: TestioToken, handler: @escaping ServerRetrievalHandler) {
        let endpointString = String.init(format: TestioAPIURLStringFormat, TestioEndpoint.servers.rawValue)
        
        guard let endpointURL = URL(string: endpointString) else {
            handler(.failure(.unknown(nil)))
            return
        }

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
        
        performDataTask(withRequest: request, handler: handler)
    }
    
    private func performDataTask<Type: Codable>(withRequest request: URLRequest, handler: @escaping (Result<Type, TestioAPIError>) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                handler(.failure(.unknown(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(.failure(.unknown(nil)))
                return
            }
            
            guard self.acceptableStatusCodes ~= httpResponse.statusCode else {
                let customError = TestioAPIError.error(forStatusCode: httpResponse.statusCode)
                handler(.failure(customError))
                return
            }

            guard let data = data,
                let decodedType = try? Type.decode(fromData: data) else {
                    handler(.failure(.unknown(nil)))
                    return
            }
            
            handler(.success(decodedType))
        }
        
        task.resume()
    }
    
}
