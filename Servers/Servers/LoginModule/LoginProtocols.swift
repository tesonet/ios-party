//
//  LoginProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

protocol LoginPresenterProtocol: class {
    
    var backgroundImage: UIImage { get }
    var backgroundLogoImage: UIImage { get }
    var isLoginButtonEnabled: Bool { get }
    var loadingMessage: String { get }

    init(view: LoginViewProtocol, networkService: NetworkServiceProtocol)
    
    func logIn()
    func didChange(username: String?, password: String?)
}

protocol LoginViewProtocol: class {
    func updateUI(isLoading: Bool)
    func show(error: Error)
    func setLoginButton(enabled: Bool)
}

