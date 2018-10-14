//
//  Router.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

class Router {
    enum AppNavigation {
        case login
        case loginWithMessage(String)
        case loading
        case serversList
    }
    
    class func getVC(forNavigation navigation: Router.AppNavigation) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch navigation {
        case .login:
            return storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        case .loginWithMessage(let message):
            guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return getVC(forNavigation:.login)
            }
            loginViewController.errorMessage = message
            return loginViewController
        case .loading:
            return storyboard.instantiateViewController(withIdentifier: "LoadingViewController")
        case .serversList:
            return storyboard.instantiateViewController(withIdentifier: "ServersListViewController")
        }
    }
}

extension Router {
    class func navigate(_ navigation: Router.AppNavigation) {
        if let fromVC = Router.getTopVC() {
            let toVC = getVC(forNavigation: navigation)
            
            switch navigation {
            case .login, .serversList:
                Router.navigate(toVC, fromViewController: fromVC, replace: true)
            default:
                Router.navigate(toVC, fromViewController: fromVC)
            }
        }
    }
    
    fileprivate class func getRootNavigationVC() -> UINavigationController? {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            if let navController = rootVC as? UINavigationController {
                return navController
            }
        }
        
        return nil
    }
    
    fileprivate class func getTopVC() -> UIViewController? {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            if let navController = rootVC as? UINavigationController {
                if let vc = navController.viewControllers.last {
                    return vc
                }
            }
            
            return rootVC
        }
        
        return nil
    }
    
    fileprivate class func navigate(_ toViewController: UIViewController, fromViewController: UIViewController, replace: Bool = false) {
        if let mainNavigationVC = Router.getRootNavigationVC() {
            mainNavigationVC.pushViewController(toViewController, animated: true)
            if (replace) {
                mainNavigationVC.viewControllers = [toViewController]
            }
        }
    }
}
