//
//  Coordinator.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

final class Coordinator {
    
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    enum Navigation {
        case login
        case list
    }
    
    func navigate(_ navigation: Navigation) {
        switch navigation {
        case .login:
            showLogin()
        case .list:
            showMain()
        }
    }
    
    private func showMain() {
        let listVC = ListViewController()
        listVC.coordinator = self
        window?.rootViewController = UINavigationController(rootViewController: listVC)
        window?.makeKeyAndVisible()
    }
    
    private func showLogin() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let navigation: Navigation = AuthenticationStorage.shared.isLoggedIn ? .list : .login
        navigate(navigation)
    }
}
