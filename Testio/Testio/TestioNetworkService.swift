//
//  TestioNetworkService.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

enum TestioError: Error {
    case unauthorized
    case unknown
}

enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

private let TestioAPIURLStringFormat = "http://playground.tesonet.lt/v1/%@"

private enum TestioEndpoint: String {
    case tokens
    case servers
}

protocol ServersRetrievingType {
    
}

typealias AuthenticationHandler = (Result<TestioToken, TestioError>) -> ()

protocol AuthorizationPerformingType {

    func authenticate(user: TestioUser, handler: @escaping AuthenticationHandler)
    
}

class TestioNetworkService: AuthorizationPerformingType, ServersRetrievingType {

    func authenticate(user: TestioUser, handler: @escaping AuthenticationHandler) {

        let endpointString = String.init(format: TestioAPIURLStringFormat, TestioEndpoint.tokens.rawValue)
        
        guard let encodedCredentials = try? user.encode(),
            let endpointURL = URL(string: endpointString) else {
            handler(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.httpBody = encodedCredentials
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let authenticationTask = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode != 401 else {
                handler(.failure(.unauthorized))
                return
            }

            guard error == nil,
                let data = data,
                let token = try? TestioToken.decode(fromData: data) else {
                handler(.failure(.unknown))
                return
            }
            
            handler(.success(token))
        }
        
        authenticationTask.resume()
    }
    
}
