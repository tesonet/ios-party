//
//  AppDelegate.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Declarations
    var window: UIWindow?
    
    // MARK: - Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
}

