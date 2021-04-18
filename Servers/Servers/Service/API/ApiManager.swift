//
//  ApiManager.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation

final class ApiManager: ApiManagerProtocol {
    private let networkService: NetworkServiceProtocol
    private let decodableService: DecodableServiceProtocol
    private let keychainService: KeychainServiceProtocol
    
    required init(networkService: NetworkServiceProtocol,
                  decodableService: DecodableServiceProtocol,
                  keychainService: KeychainServiceProtocol) {
        self.networkService = networkService
        self.decodableService = decodableService
        self.keychainService = keychainService
    }
    
    func login(username: String, password: String, completion: ((Result<String, Error>) -> ())?) {
        
        let endpoint = ApiEndpoint.login(username: username, password: password)
        
        networkService.performRequest(url: endpoint.url, method: .POST, headers: endpoint.headers, body: endpoint.body) { [weak self] (result) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let decodedResult = self.decodableService.authValue(data: data)
                    switch decodedResult {
                    case .success(let authModel):
                        completion?(.success(authModel.token))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func getServers(completion: ((Result<[ServerModel], Error>) -> ())?) {
        guard let token = keychainService.token else { return }
        let endpoint = ApiEndpoint.servers(token: token)
        
        networkService.performRequest(url: endpoint.url, method: .POST, headers: endpoint.headers, body: endpoint.body) { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    let decodedResult = self.decodableService.serverValue(data: data)
                    switch decodedResult {
                    case .success(let servers):
                        completion?(.success(servers))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                    break
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
    }
}
