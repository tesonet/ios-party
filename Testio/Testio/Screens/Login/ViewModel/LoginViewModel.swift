//
//  InfoListViewModel.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

final class LoginViewModel: LoginViewModelProtocol {
    
    private let loginService: LoginServiceProtocol
    private weak var coordinator: CoordinatorProtocol?
    
    init(loginService: LoginServiceProtocol, coordinator: CoordinatorProtocol) {
        self.loginService = loginService
        self.coordinator = coordinator
    }
    
    func start() {}
}

//MARK: - UI events

extension LoginViewModel {
    func login(username: String, password: String) {
        loginService.logIn(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let authorizatioData):
                //TODO: - store token
                self?.coordinator?.displayNextScreen()
            case .failure(let error):
                self?.coordinator?.displayMessage(error.description)
            }
        }
    }
}
