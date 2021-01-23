//
//  AppDelegate+Window.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

extension AppDelegate {
    
    // MARK: - Methods
    func prepareWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = initialViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
    
    // MARK: - View Controllers
    func initialViewController() -> UIViewController {
        return LoginViewController()
    }
}
