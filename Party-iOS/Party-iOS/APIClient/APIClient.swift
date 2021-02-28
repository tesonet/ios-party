//
//  APIClient.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

protocol Authorizable {
    var accessToken: String { get }
    var tokenType: String { get }
}

extension Authorizable {
    var authorization: String {
        tokenType + " " + accessToken
    }
}

struct APIClient {
    let session: URLSessionProtocol
    let headers: Headers?
    
    typealias APIClientResult = Result<(URLResponse, Data), APIClientError>
    typealias Completion = (APIClientResult) -> Void
    
    var authenticationDelegate: AuthenticationStorageDelegate
 
    init(session: URLSessionProtocol = URLSession.shared, headers: Headers? = nil, authenticationDelegate: AuthenticationStorageDelegate) {
        self.session = session
        self.headers = headers
        self.authenticationDelegate = authenticationDelegate
    }
    
    private func _request(endPoint: EndPoint, isAuthorized: Bool = true, completion: @escaping NetworkConnection.Completion) {
        var headers = self.headers ?? Headers()
        if isAuthorized { headers["Authorization"] = authenticationDelegate.authentication().authorization }
        let connection = NetworkConnection(session: session, additionalHeaders: headers)
        connection.request(endPoint, completion: completion)
    }
}

extension APIClient {
    func request(_ endPoint: EndPoint, completion: @escaping Completion) {
        _request(endPoint: endPoint) { (result) in
            switch result {
            case .success(let success): completion(.success(success))
            case .failure(let error): completion(.failure(.networkError(error)))
            }
        }
    }
    
    func request<T: Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, APIClientError>) -> Void) {
        request(endPoint) { (result) in
            switch result {
            case .success(let success):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(T.self, from: success.1)
                    completion(.success(decoded))
                } catch let decodingError {
                    let clientDecodingError = APIClientError.decodingError(decodingError)
                    completion(.failure(clientDecodingError))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

// MARK: - Authentication
extension APIClient {
    func authenticate(username: String, password: String, completion: @escaping (Result<Authorizable, APIClientError>) -> Void) {
        let endPoint = API.authenticate(username: username, password: password)
        _request(endPoint: endPoint, isAuthorized: false, completion: authenticationCompletionHandler(completion: completion))
    }
    
    private func authenticationCompletionHandler(completion: @escaping (Result<Authorizable, APIClientError>) -> Void) -> NetworkConnection.Completion {
        return { (result) in
            switch result {
            case .success(let success):
                let decoder = JSONDecoder()
                do {
                    let authorization = try decoder.decode(Authorization.self, from: success.1)
                    self.authenticationDelegate.didUpdateAuthentication(authorization)
                    completion(.success(authorization))
                } catch let parsingError {
                    let error = APIClientError.decodingError(parsingError)
                    completion(.failure(error))
                }
            case .failure(let failure):
                let error = APIClientError.networkError(failure)
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Authorization
private extension APIClient {
    private struct Authorization: Authorizable, Codable {
        let accessToken: String
        let tokenType: String = "Bearer"
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "token"
        }
    }
}

enum APIClientError: Error {
    case networkError(ConnectionError)
    case decodingError(Error)
}


protocol AuthenticationStorageDelegate {
    func didUpdateAuthentication(_ authentication: Authorizable)
    func authentication() -> Authorizable
}
