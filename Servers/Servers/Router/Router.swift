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
              let loginVC = moduleBuilder?.createLoginModule(router: self) else { return }
        navigationController.viewControllers = [loginVC]
    }
    
    func showServers() {
        
    }
    
    func popToRoot() {
        
    }
}
