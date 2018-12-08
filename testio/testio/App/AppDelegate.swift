//
//  AppDelegate.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 04/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        Notification.loggedIn.observe(with: self, selector: #selector(loggedIn))
        Notification.logOut.observe(with: self, selector: #selector(logOut))
        
        guard let navVC = Storyboard.Main.initialVC as? UINavigationController
            else { fatalError("Root view controller must be UINavigationController") }
        window?.rootViewController = navVC
        if !User.didSignIn || User.auth?.token == nil {
            showLogin()
        }
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PersistentContainer.shared.saveContext()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AppDelegate {
    
    @objc func logOut() {
        try? User.authorized(nil)
        PersistentContainer.shared.deleteAll(withRequest: Server.fetchRequest())
        
        updateUI(loggedIn: false)
    }
    
    @objc func loggedIn() {
        updateUI(loggedIn: true)
    }
    
    private func updateUI(loggedIn: Bool) {
        guard let navVC = window?.rootViewController as? UINavigationController
            else { fatalError("Root view controller must be UINavigationController") }
        if loggedIn {
            UIView.transition(with:navVC.view, duration: Const.standardAnimationDuration, options:.transitionCrossDissolve, animations: {
                navVC.popToRootViewController(animated: false)
            })
        } else {
            showLogin()
        }
    }
    
    private func showLogin() {
        guard let navVC = window?.rootViewController as? UINavigationController
            else { fatalError("Root view controller must be UINavigationController") }
        guard let loginVC = Storyboard.Login.initialVC
            else { fatalError("Login view controller missing?") }
        
        UIView.transition(with:navVC.view, duration: Const.standardAnimationDuration, options:.transitionCrossDissolve, animations: {
            navVC.pushViewController(loginVC, animated: false)
        })
    }
}
