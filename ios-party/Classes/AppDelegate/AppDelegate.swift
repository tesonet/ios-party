//
//  AppDelegate.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Declarations
    var window: UIWindow?
    
    // MARK: - Methods
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        prepareWindow()
        return true
    }
}
