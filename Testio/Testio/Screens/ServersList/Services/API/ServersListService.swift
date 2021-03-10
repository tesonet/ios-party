//
//  CarInfoService.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

final class ServersListService: ServersListServiceProtocol {
 
    private(set) var isLoadingData = false
 
    let apiClient: ApiClientProtocol
    let dataDecodingService: ServersListDataDecodingServiceProtocol
    
    init(apiClient: ApiClientProtocol, dataDecodingService: ServersListDataDecodingServiceProtocol) {
        self.apiClient = apiClient
        self.dataDecodingService = dataDecodingService
    }
    
    func servers(token: String, completion: @escaping (Result<[Server], ServersListServiceError>) -> ()) {
        isLoadingData = true
        let endpoint = Endpoint.servers(token: token)
        apiClient.post(url: endpoint.url, body: endpoint.body, headers: endpoint.headers) { [weak self] result in
            self?.isLoadingData = false
            switch result {
            case .success(let data):
                let dataTransformationResult = self?.dataDecodingService.value(from: data)
                DispatchQueue.main.async {
                    switch dataTransformationResult {
                    case .success(let servers):
                        completion(.success(servers))
                    case .failure(let error):
                        completion(.failure(.dataDecodingFailed(error.localizedDescription)))
                    default:
                        ()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(error.description)))
                }
            }
        }
    }
}
