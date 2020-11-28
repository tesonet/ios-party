//
//  AppDelegate+Launch.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

extension AppDelegate {
    
    func initialNavigationController() -> UIWindow? {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = LoginViewController()
        window.makeKeyAndVisible()
        
        return window
    }
}
