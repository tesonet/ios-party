//
//  LoginRepository.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 13/04/2021.
//

import Foundation
import Combine

enum LoginError: LocalizedError {
    case unknownError
    case unathorized
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "Unknown Server Error"
        case .unathorized: return "Wrong username or password"
        }
    }
}

struct LoginRepository: LoginRepositoryProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(username: String, password: String) -> AnyPublisher<String, Error> {
        let stringUrl = "https://playground.tesonet.lt/v1/tokens"
        guard let url = URL(string: stringUrl) else {
            return Fail<String, Error>(error: URLError(.badURL, userInfo: [NSURLErrorFailingURLErrorKey: stringUrl])).eraseToAnyPublisher()
        }
        
        let loginRequest = LoginRequest(username: username, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(loginRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return session.dataTaskPublisher(for: request)
            .tryMap{ result in
                
                guard let response = result.response as? HTTPURLResponse else { throw LoginError.unknownError }
                
                guard response.statusCode != 401 else { throw LoginError.unathorized }
                
                guard (199...299).contains(response.statusCode) else { throw LoginError.unknownError }
                
                return result.data
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .map(\.token)
            .eraseToAnyPublisher()
    }
}
