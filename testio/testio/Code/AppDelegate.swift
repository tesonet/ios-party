//
//  AppDelegate.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootViewController: RootViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.rootViewController = RootViewController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = self.rootViewController
        self.window!.makeKeyAndVisible()
        
        return true
    }
}
