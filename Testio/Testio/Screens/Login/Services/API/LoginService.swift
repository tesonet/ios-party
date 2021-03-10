//
//  CarInfoService.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

final class LoginService: LoginServiceProtocol {
    
    private(set) var isLoadingData = false
 
    let apiClient: ApiClientProtocol
    let dataDecodingService: AuthorizationDataDecodingServiceProtocol
    
    init(apiClient: ApiClientProtocol, dataDecodingService: AuthorizationDataDecodingServiceProtocol) {
        self.apiClient = apiClient
        self.dataDecodingService = dataDecodingService
    }
    
    func logIn(username: String, password: String, completion: @escaping (Result<AuthorizationData, LoginServiceError>) -> ()) {
        isLoadingData = true
        
        let endpoint = Endpoint.logIn(user: username, password: password)        
        apiClient.post(url: endpoint.url, body: endpoint.body, headers: endpoint.headers) { [weak self] result in
            self?.isLoadingData = false
            switch result {
            case .success(let data):
                let dataTransformationResult = self?.dataDecodingService.value(from: data)
                DispatchQueue.main.async {
                    switch dataTransformationResult {
                    case .success(let authorizationData):
                        completion(.success(authorizationData))
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
