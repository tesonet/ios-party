//
//  AuthGateway.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 30.05.2021.
//

import Foundation
import Combine

struct AuthGateway {
    private let _session: URLSession
    
    init(session: URLSession = .shared) {
        _session = session
    }
    
    func authenticate(username: String, password: String) -> AnyPublisher<User, Error> {        
        struct LoginRequest: Encodable {
            let username: String
            let password: String
        }

        let stringUrl = "https://playground.tesonet.lt/v1/tokens"
        guard let url = URL(string: stringUrl) else {
            return Fail<User, Error>(error: URLError(.badURL, userInfo: [NSURLErrorFailingURLErrorKey: stringUrl])).eraseToAnyPublisher()
        }
        
        let loginRequest = LoginRequest(username: username, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(loginRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return _session.dataTaskPublisher(for: request)
            .tryMap { result in
                
                guard let response = result.response as? HTTPURLResponse else { throw NetworkError.unknownError }
                
                guard response.statusCode != 401 else { throw NetworkError.unathorized }
                
                guard (199...299).contains(response.statusCode) else { throw NetworkError.unknownError }
                
                return result.data
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
