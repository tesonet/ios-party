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
        
        window = initialNavigationController()
        
        return true
    }
}

