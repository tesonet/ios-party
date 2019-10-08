//
//  AppDelegate.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dependencyContainer: DependencyContainer?
    var appFlowStateProcessor: FlowStateProcessor?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        print("UIApplication: didFinishLaunchingWithOptions")
        #endif
        window = application.windows.first
        window?.makeKey()
        if #available(iOS 13.0, *) { } else {
            #if DEBUG
            print("Pre - iOS 13 processing")
            #endif
            let dependency = AppDependencyContainer()
            dependency.window = window
            appFlowStateProcessor = AppFlowStateProcessor(dependency: dependency)
            dependency.flowStateProcessor = appFlowStateProcessor
            dependencyContainer = dependency
            appFlowStateProcessor?.appFlowState = .none
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

