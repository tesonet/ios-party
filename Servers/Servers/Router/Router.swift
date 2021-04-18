//
//  Router.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController,
              let builder = moduleBuilder else { return }
                      
        let loginViewController = builder.createLoginModule(router: self)
    
        navigationController.viewControllers = [loginViewController]
        navigationController.setNavigationBarHidden(true, animated: false)
        
        if builder.isLoggedIn {
            let serversViewController = builder.createServersModule(router: self)
            navigationController.pushViewController(serversViewController, animated: false)
        }
        
    }
    
    func showServers() {
        guard let serversVC = moduleBuilder?.createServersModule(router: self) else { return }
        navigationController?.pushViewController(serversVC, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
