//
//  Router.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

final class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    private var animator: TransitionAnimator
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
        self.animator = moduleBuilder.createTransitionAnimator()
    }
    
    func initialViewController() {
        guard let navigationController = navigationController,
              let builder = moduleBuilder else { return }
                      
        let loginViewController = builder.createLoginModule(router: self)
    
        navigationController.viewControllers = [loginViewController]
        navigationController.setNavigationBarHidden(true, animated: false)
        
        if builder.isLoggedIn {
            showServers()
        }
    }
    
    func showServers() {
        guard let serversVC = moduleBuilder?.createServersModule(router: self) else { return }
        
        serversVC.modalPresentationStyle = .fullScreen
        serversVC.transitioningDelegate = animator
        
        navigationController?.viewControllers.first?.present(serversVC, animated: true, completion: nil)
    }
    
    func backToLogin() {
        navigationController?.viewControllers.first?.transitioningDelegate = animator
        navigationController?.viewControllers.first?.dismiss(animated: true, completion: nil)
    }
}
