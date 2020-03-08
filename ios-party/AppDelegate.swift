//
//  AppDelegate.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller = MainStoryboardController.shared

    if ServerStorage.shared.list.isEmpty {
      controller.switchToSplashViewController()
    } else {
      controller.switchToServerListViewController()
    }

    controller.window.makeKeyAndVisible()
    window = controller.window

    return true

  }

}
