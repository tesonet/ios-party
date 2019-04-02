// Created by Paulius Cesekas on 01/04/2019.

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Variables
    var window: UIWindow?

    // MARK: - Methods -
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        configureWindow()
        configureInitialScene()
        return true
    }
    
    // MARK: - Helpers
    private func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        Application.shared.configure(in: window)
        self.window = window
    }

    private func configureInitialScene() {
        // TODO: - Should validate for active user session
        Application.shared.rootNavigator.navigateToLogin()
    }
}
