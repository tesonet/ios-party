//
//  AppDelegate+Window.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

fileprivate let kNavigationTransitionAnimationDuration = 0.2

extension AppDelegate {
    
    // MARK: - Methods
    func prepareWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = initialViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func switchRootViewController(to viewController: UIViewController) {
        guard let window = window else {
            log("ERROR! Could not get window")
            return
        }
        
        window.rootViewController = viewController
        UIView.transition(with: window,
                          duration: kNavigationTransitionAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { })
    }
    
    // MARK: - View Controllers
    func initialViewController() -> UIViewController {
        switch appMode {
        case .loggedIn:
            return serverListViewController()
        case .loggedOut:
            return loginViewController()
        case .dataLoading:
            return loaderViewController()
        }
    }
    
    // MARK: - View Controllers
    func loginViewController() -> UIViewController {
        return LoginViewController()
    }
    
    func serverListViewController() -> UIViewController {
        // FIXME: return proper view controller once implemented
        return UIViewController()
    }
    
    func loaderViewController() -> UIViewController {
        return LoaderViewController()
    }
}
