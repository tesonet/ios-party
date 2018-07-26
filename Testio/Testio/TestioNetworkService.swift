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

class TestioNetworkService: NSObject {

    typealias AuthenticationHandler = (Result<TestioToken, TestioError>) -> ()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    func authenticate(user: TestioUser, handler: @escaping AuthenticationHandler) {

        let endpointString = String.init(format: TestioAPIURLStringFormat, TestioEndpoint.tokens.rawValue)
        
        guard let encodedCredentials = try? encoder.encode(user),
            let endpointURL = URL(string: endpointString) else {
            handler(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.httpBody = encodedCredentials
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let authenticationTask = session.dataTask(with: request) { [unowned self] data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode != 401 else {
                handler(.failure(.unauthorized))
                return
            }
            
            guard error == nil,
                let data = data,
                let token = try? self.decoder.decode(TestioToken.self, from: data) else {
                handler(.failure(.unknown))
                return
            }
            
            handler(.success(token))
        }
        
        authenticationTask.resume()
    }
    
}
