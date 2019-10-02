//
//  Router.swift
//  Doit
//
//  Created by Артём Зиньков on 9/14/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

final class Router {
    
    public static func route(to route: Routes, _ parameter: Any? = nil) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                shared.route(to: route, parameter)
            }
        } else {
            shared.route(to: route, parameter)
        }
    }
    
    enum Routes {
        case Authorization
        case Error(description: String)
        case ServerList
    }
    
    private static var shared = Router()
    private var navigationController: UINavigationController?
    
    public static func start(with navigationController: UINavigationController) {
        shared.navigationController = shared.navigationController ?? navigationController
        if APIManager.hasToken {
            route(to: .ServerList)
        } else {
            route(to: .Authorization)
        }
    }
}

extension Router {
    
    func route(to route: Routes, _ parameter: Any? = nil) {
        
        switch route {
        case .Authorization:
            if passPrecheck(AuthorizationViewController.self) {
                return
            }
            
            if let viewController = AuthorizationViewController.instantiate() {
                navigationController?.popViewController(animated: true)
                navigationController?.present(viewController, animated: true)
            }
        case .ServerList:
            if passPrecheck(ServerListViewController.self) {
                return
            }
            
            if let viewController = ServerListViewController.instantiate() {
                navigationController?.popViewController(animated: true)
                navigationController?.pushViewController(viewController, animated: true)
            }
        case .Error(description: let description):
            let alertController = UIAlertController(title: "An Error Occured", message: description, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            navigationController?.present(alertController, animated: true)
        }
    }
    
    // Checking is there any controller for this class
    private func passPrecheck(_ T: UIViewController.Type) -> Bool {
        
        if navigationController?.topViewController?.isKind(of: T) ?? false {
            return true
        }
        
        if let viewController = navigationController?.viewControllers.first(where: { return $0.isKind(of: T) }) {
            navigationController?.show(viewController, sender: nil)
            return true
        }
        
        return false
    }
}
