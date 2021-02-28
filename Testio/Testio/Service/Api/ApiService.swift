//
//  ApiService.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

final class ApiService {
    
    private let baseURL = URL(string: "https://playground.tesonet.lt/v1/")!
        
    private let session: URLSession
    private let secureStorage: SecureStorageServiceProtocol
    
    init(secureStorage: SecureStorageServiceProtocol) {
        session = URLSession.shared
        self.secureStorage = secureStorage
    }
    
    private func error(from response: URLResponse?) -> ApiServiceError? {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }

        let statusCode = response.statusCode
        switch statusCode {
        case 401:
            return .unauthorized
        case 200:
            return nil
        default:
            return .serverError
        }
    }
}

extension ApiService: ApiServiceProtocol {
    
    func auth(credentials: DomainCredentials, completion: ((Result<Void, ApiServiceError>) -> ())?) {
        let performCompletion = { (result: Result<Void, ApiServiceError>) in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
        
        let url = baseURL.appendingPathComponent("tokens", isDirectory: false)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(credentials)
        } catch {
            performCompletion(.failure(.dataNotEncoded))
            return
        }
        
        session.dataTask(with: request) { [weak self] data, response, error in
            if let error = self?.error(from: response) {
                performCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                performCompletion(.failure(.dataNotLoaded))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(ApiServiceTokenResponseModel.self, from: data)
                self?.secureStorage.authToken = model.token
                performCompletion(.success(()))
            } catch {
                performCompletion(.failure(.dataNotDecoded))
            }
        }.resume()
    }
    
    func loadServers(completion: ((Result<[DomainServerItem], ApiServiceError>) -> ())?) {
        let performCompletion = { (result: Result<[DomainServerItem], ApiServiceError>) in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
        
        guard let token = secureStorage.authToken else {
            performCompletion(.failure(.unauthorized))
            return
        }
        
        let url = baseURL.appendingPathComponent("servers", isDirectory: false)
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { [weak self] data, response, error in
            if let error = self?.error(from: response) {
                performCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                performCompletion(.failure(.dataNotLoaded))
                return
            }
            
            do {
                let items = try JSONDecoder().decode([DomainServerItem].self, from: data)
                performCompletion(.success(items))
            } catch {
                performCompletion(.failure(.dataNotDecoded))
            }
        }.resume()
    }
}
