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
    private var router: RouterProtocol?
    private weak var vc: LoginViewProtocol?
    
    private var usernameInput: String?
    private var passwordInput: String?
    
    required init(view: LoginViewProtocol, apiManager: ApiManagerProtocol, router: RouterProtocol) {
        self.vc = view
        self.apiManager = apiManager
        self.router = router        
    }
    
    func logIn() {
        guard let userName = usernameInput,
              let password = passwordInput else { return }
        
        vc?.updateUI(isLoading: true)

        apiManager.login(username: userName, password: password) { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.apiManager.save(token: token)
                self?.router?.showServers()
            case .failure(let error):
                self?.vc?.show(error: error)
            }
            
            DispatchQueue.main.async {
                self?.vc?.updateUI(isLoading: false)
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


