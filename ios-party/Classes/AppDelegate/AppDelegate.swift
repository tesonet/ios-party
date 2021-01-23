//
//  AppDelegate.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Enums
    enum AppModeType {
        case loggedIn
        case loggedOut
    }
    
    // MARK: - Declarations
    var window: UIWindow?
    var appMode: AppModeType = .loggedOut
    
    // MARK: - Dependencies
    let applicationRepository: ApplicationRepositoryInterface = ApplicationRepository()
    let keychainRepository: KeychainRepositoryInterface = KeychainRepository()
    let authorization: AuthorizationInterface = Authorization.shared
    
    // MARK: - Methods
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        resetKeychainRepositoryOnFreshInstallation()
        setupAppMode()
        startObservingAuthorizationNotifications()
        prepareWindow()
        incrementApplicationLaunchCount()
        
        return true
    }
    
    // MARK: - Application Launch Counter
    func incrementApplicationLaunchCount() {
        applicationRepository.incrementLaunchCount()
    }
    
    // MARK: - App Mode
    func setupAppMode() {
        if authorization.isLoggedIn() {
            appMode = .loggedIn
        } else {
            appMode = .loggedOut
        }
    }
    
    func switchToLoggedInMode() {
        guard appMode != .loggedIn else {
            log("ERROR! App is already in logged in mode")
            return
        }
        
        appMode = .loggedIn
        switchRootViewController(to: serverListViewController())
    }
    
    func switchToLoggedOutMode() {
        guard appMode != .loggedOut else {
            log("ERROR! App is already in logged out mode")
            return
        }
        
        appMode = .loggedOut
        switchRootViewController(to: loginViewController())
    }
    
    // MARK: - Keychain Repository
    func resetKeychainRepositoryOnFreshInstallation() {
        if applicationRepository.launchCount() <= 0 {
            keychainRepository.reset()
        }
    }
}
