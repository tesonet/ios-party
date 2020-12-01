//
//  AppDelegate+Launch.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

extension AppDelegate {
    
    func initialViewController() {
    
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
    }
    
    func logedInViewController() {
        
        window?.rootViewController = ServerListViewController()
        window?.makeKeyAndVisible()
    }
}
