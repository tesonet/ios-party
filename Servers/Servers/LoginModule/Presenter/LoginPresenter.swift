//
//  LoginPresenter.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

enum LoadingMessage: String {
    case fetchingServers = "Fetching the list.."
}

class LoginPresenter: LoginPresenterProtocol {
    
    var backgroundImage: UIImage {
        return UIImage(named: "backgroundImage")!
    }
    
    var backgroundLogoImage: UIImage {
        return UIImage(named: "logoWhiteImage")!
    }
    
    var isLoginButtonEnabled: Bool {
        return !(usernameInput ?? "").isEmpty && !(passwordInput ?? "").isEmpty
    }
    
    var loadingMessage: String {
        return LoadingMessage.fetchingServers.rawValue
    }
    
    private let apiManager: ApiManagerProtocol

    private weak var vc: LoginViewProtocol?
    
    private var usernameInput: String?
    private var passwordInput: String?
    
    required init(view: LoginViewProtocol, apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func logIn() {
        guard let userName = usernameInput,
              let password = passwordInput else { return }
        
        vc?.updateUI(isLoading: true)

        apiManager.login(username: userName, password: password) { [weak self] (result) in
            self?.vc?.updateUI(isLoading: false)
            
            switch result {
            case .success(let token): break
            case .failure(let error):
                self?.vc?.show(error: error)
            }
        }
    }
    
    func didChange(username: String?, password: String?) {
        self.usernameInput = username
        self.passwordInput = password
        validateInputs()
    }
    
    private func validateInputs() {
        vc?.setLoginButton(enabled: isLoginButtonEnabled)
    }
}


