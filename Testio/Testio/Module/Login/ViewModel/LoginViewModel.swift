//
//  LoginViewModel.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import Foundation

final class LoginViewModel {
    
    let apiService: ApiServiceProtocol
    
    weak var delegate: LoginViewModelDelegate?
    
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
}

extension LoginViewModel: LoginViewModelProtocol {
    func login(username: String, password: String) {
        guard !username.isEmpty, !password.isEmpty else {
            return
        }
        
        delegate?.didStartLogin()
        
        let model = DomainCredentials(username: username, password: password)
        apiService.auth(credentials: model) { [delegate] result in
            switch result {
            case .success:
                delegate?.didFinishLoginWithSuccess()
            case let .failure(error):
                let message: String
                switch error {
                case .unauthorized:
                    message = "Invalid credentials"
                default:
                    message = "Network error"
                }
                delegate?.didFinishLoginWithError(error: message)
            }
        }
    }
}
