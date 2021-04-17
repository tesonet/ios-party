//
//  NetworkService.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import Foundation

enum HTTPMethod: String {
    case POST = "POST"
}

enum NetworkError: Error {
    case invalidURL
    case notHTTPURLResponse
    case invalidResponseData
    case unauthorized
    case unknownError
}

protocol NetworkServiceProtocol {
    func performRequest(url: URL, method: HTTPMethod, headers: [String: String], body: Data?, completion: ((Result<Data, NetworkError>) -> ())?)
}

final class NetworkService: NetworkServiceProtocol {
    
    func performRequest(url: URL, method: HTTPMethod, headers: [String : String], body: Data?, completion: ((Result<Data, NetworkError>) -> ())?) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if method == .POST {
            request.httpBody = body
        }
        
        perform(request: request, headers: headers, completion: completion)
    }
    
    private func perform(request: URLRequest, headers: [String: String]?, completion: ((Result<Data, NetworkError>) -> ())?) {
        let sessionConfiguration = URLSessionConfiguration.default
        
        if let headers = headers {
            sessionConfiguration.httpAdditionalHeaders = headers
        }
        
        let session = URLSession(configuration: sessionConfiguration)
        
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion?(.failure(NetworkError.notHTTPURLResponse))
                return
            }
            
            let responseCode = response.statusCode
            
            switch responseCode {
            case 200...204:
                if let data = data {
                    completion?(.success(data))
                } else {
                    completion?(.failure(NetworkError.invalidResponseData))
                }
            case 401:
                completion?(.failure(NetworkError.unauthorized))
            default:
                completion?(.failure(NetworkError.unknownError))
            }
        }.resume()
    }
}
