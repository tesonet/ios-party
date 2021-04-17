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
    
    private weak var vc: LoginViewProtocol?
    private let networkService: NetworkServiceProtocol
    
    private var usernameInput: String?
    private var passwordInput: String?
    
    required init(view: LoginViewProtocol, networkService: NetworkServiceProtocol) {
        self.vc = view
        self.networkService = networkService
    }
    
    func logIn() {
        vc?.updateUI(isLoading: true)
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


