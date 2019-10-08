//
//  SceneDelegate.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var dependencyContainer: DependencyContainer?
    var appFlowStateProcessor: FlowStateProcessor?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            window?.makeKeyAndVisible()
        }
        #if DEBUG
        print("UIScene: willConnectTo")
        #endif
        let dependency = AppDependencyContainer()
        dependency.window = window
        window?.makeKey()
        appFlowStateProcessor = AppFlowStateProcessor(dependency: dependency)
        dependency.flowStateProcessor = appFlowStateProcessor
        dependencyContainer = dependency
        appFlowStateProcessor?.appFlowState = .none
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        #if DEBUG
        print("UIScene: dodDisconnect")
        #endif
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        #if DEBUG
        print("UIScene: didBecomeActive")
        #endif
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        #if DEBUG
        print("UIScene: sceneWillResignActive")
        #endif
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        //Fetch resources
        #if DEBUG
        print("UIScene: sceneWillEnterForeground")
        #endif
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        #if DEBUG
        print("UIScene: sceneWillEnterForeground")
        #endif
    }


}

