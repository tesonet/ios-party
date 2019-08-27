//
//  AppCordinator.swift
//  testio
//
//  Created by Justinas Baronas on 19/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit


final class AppNavigator: Navigator {
    
    // MARK: - Shared instance
    static var shared = AppNavigator()
    private init() { }

    
    private var window = UIWindow(frame: UIScreen.main.bounds)

    // MARK: - Routing
    
    enum Destination {
        case loginView
        case serverListView(with: [Server])
    }
    
    
    // MARK: - Navigator
    
    func navigate(from fromDestination: UIViewController, to destination: Destination) {
        transition(from: fromDestination, to: makeViewController(for: destination))
    }
    
    func navigate(to destination: Destination) {
        let rootVC = makeViewController(for: destination)
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }
    
    
    // MARK: - Private
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .loginView:
            return LoginViewController()
        case .serverListView(let servers):
            return ServersListViewController(with: servers)
        }
    }
    
    private func transition(from fromVC: UIViewController, to toVC: UIViewController) {
        toVC.view.frame = fromVC.view.frame
        toVC.view.layoutIfNeeded()
        UIView.transition(
            from: fromVC.view,
            to: toVC.view,
            duration: 0.3,
            options: [.transitionCrossDissolve], completion: { _ in
                self.window.rootViewController = toVC
                self.window.makeKeyAndVisible()
        })
    }
    
    
}
