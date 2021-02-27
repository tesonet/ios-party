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
        let navigationController = UINavigationController(rootViewController: listVC)
        let completion: (Bool) -> Void = { [weak self] _ in
            guard let self = self else { return }
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        guard let currentView = window?.rootViewController?.view else {
            completion(true)
            return
        }
        UIView.transition(from: currentView, to: navigationController.view, duration: 0.5, options: .transitionCrossDissolve, completion: completion)
 
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
