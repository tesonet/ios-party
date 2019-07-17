//
//  AppDelegate.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureAPIClient()
        
        return true
    }

    private func configureAPIClient() {
        let apiClient = ApiClient(baseUrl: Backend.baseUrl)
        ApiClient.shared = apiClient
    }
}

