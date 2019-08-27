//
//  AppDelegate.swift
//  testio
//
//  Created by Justinas Baronas on 11/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit
import CoreData
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        navigateDependingOnState()
        
        return true
    }
    
    private func navigateDependingOnState() {
       
        if Authentication.isUserLoggedIn {
            CoreDataManager.shared.getServers { servers in
                AppNavigator.shared.navigate(to: .serverListView(with: servers))
            }
        } else {
            AppNavigator.shared.navigate(to: .loginView)
        }
        
        let f = KeychainSwift()
        f.clear()
    }
   

    func applicationWillTerminate(_ application: UIApplication) {
       CoreDataManager.shared.saveContext()
    }

}
