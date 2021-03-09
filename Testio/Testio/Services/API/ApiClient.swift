//
//  CarInfoApiClient.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

final class ApiClient: ApiClientProtocol {
    
    func post(url: URL, body: Data?, headers: [String: String], completion: @escaping (Result<Data, ApiClientError>) -> ()) {
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        headers.forEach { header, value in
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(Int.max, "Response is not an instance of HTTPURLResponse")))
                return
            }
            let responseCode = httpResponse.statusCode
            switch responseCode {
            case 200...204:
                if let responseData = data {
                    completion(.success(responseData))
                } else {
                    completion(.failure(.requestFailed(responseCode, "Cannot get response data")))
                }
            case 401:
                completion(.failure(.requestFailed(responseCode, error?.localizedDescription ?? Localization.Error.unauthorized)))
            case 402...405:
                completion(.failure(.requestFailed(responseCode, error?.localizedDescription ?? Localization.Error.unknown)))
            default:
                completion(.failure(.requestFailed(responseCode, "Unknown response code: \(responseCode)")))
            }
        }
        task.resume()
    }
}
