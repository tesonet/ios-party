//
//  AppDelegate.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManager
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Alamofire.SessionManager.default.adapter = ApiSessionHandler.sharedInstance
        Alamofire.SessionManager.default.retrier = ApiSessionHandler.sharedInstance
        IQKeyboardManager.shared().isEnabled = true
        
        #if DEBUG
            NetworkActivityLogger.shared.startLogging()
            NetworkActivityLogger.shared.level = .debug
        #endif
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
