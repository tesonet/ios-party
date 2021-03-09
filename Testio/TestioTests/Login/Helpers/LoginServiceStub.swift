//
//  LoginServiceStub.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/9/21.
//

import Foundation
@testable import Testio

final class LoginServiceStub: LoginServiceProtocol {
    var apiClient: ApiClientProtocol
    var isLoadingData: Bool
    
    var successfullyLoaded = false
    var loadedAuthorizationData: AuthorizationData? = nil
    
    init(apiClient: ApiClientProtocol, isLoadingData: Bool) {
        self.apiClient = apiClient
        self.isLoadingData = isLoadingData
    }
    
    func logIn(username: String, password: String, completion: @escaping (Result<AuthorizationData, LoginServiceError>) -> ()) {
        if successfullyLoaded {
            completion(.success(loadedAuthorizationData!))
        } else {
            completion(.failure(.requestFailed("Failed request")))
        }
    }

}
