//
//  LoginPresenterProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import UIKit

protocol LoginPresenterProtocol: class {
    
    var backgroundImage: UIImage { get }
    var backgroundLogoImage: UIImage { get }
    var isLoginButtonEnabled: Bool { get }
    var loadingMessage: String { get }

    init(view: LoginViewProtocol, apiManager: ApiManagerProtocol, router: RouterProtocol)
    
    func logIn()
    func didChange(username: String?, password: String?)
}
