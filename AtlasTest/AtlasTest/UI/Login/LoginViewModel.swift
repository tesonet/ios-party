//
//  LoginViewModel.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

enum LoginResult {
    case error(error: AppError)
    case success
}

protocol LoginViewModel: AnyObject {
    var username: String { get set }
    var password: String { get set }
    var view: LoginViewController? { get set }
    
    init(dependency: DependencyContainer, completionHandler: @escaping ((Bool) -> Void))
    func usernameChanged(to value: String)
    func passwordChanged(to value: String)
    func loginButtonTapped()
}

class AppLoginViewModel: LoginViewModel {
    var username: String
    var password: String
    unowned private var dependency: DependencyContainer
    unowned var view: LoginViewController?
    private var completionHandler: ((Bool) -> Void)
    
    required init(dependency: DependencyContainer, completionHandler: @escaping ((Bool) -> Void)) {
        self.dependency = dependency
        self.completionHandler = completionHandler
        self.username = ""
        self.password = ""
    }
    
    func usernameChanged(to value: String) {
        username = value
    }
    
    func passwordChanged(to value: String) {
        password = value
    }
    
    func loginButtonTapped() {
        if username.isEmpty || password.isEmpty {
            dependency.errorHandler?.process(error: AppTestError.authError)
            username = ""
            password = ""
            view?.setInitUI()
            return
        }
        view?.setBeingAuthorizedUI()
        loginWith(username: username, password: password)
    }
}
    
private extension AppLoginViewModel {
    func loginWith(username: String, password: String) {
        dependency.apiWorker?.login(username: username, password: password) { [weak self] result in
            switch result {
            case .error(let error):
                self?.dependency.errorHandler?.process(error: error)
                self?.view?.setInitUI()
            case .response(let result):
                guard let token = result as? String else { return }
                LocalStorage.saveToken(token)
                LocalStorage.saveUser(name: username, password: password)
                self?.processLogin(result: .success)
            }
        }
    }
    
    func processLogin(result: LoginResult) {
        switch result {
        case .error(error: let error):
            dependency.errorHandler?.process(error: error)
            view?.setInitUI()
        case .success:
            completionHandler(true)
        }
    }
}
