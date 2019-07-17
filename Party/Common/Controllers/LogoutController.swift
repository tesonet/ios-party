//
//  LogoutController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class LogoutController {
    
    // MARK - Dependencies
    
    weak var source: UIViewController?
    
    // token storage for auth token
    let tokenStorage: AuthTokenStorage
    
    // MARK: - Init
    
    init(source: UIViewController,
         tokenStorage: AuthTokenStorage = AuthTokenStorage()) {
        self.source = source
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Public Methods
    
    func logout() {
        tokenStorage.clear()
        routeToLoginScreen()
    }
    
    // MARK: - Private Methods
    
    /// Navigates app to login screen.
    private func routeToLoginScreen() {
        let destination: UIViewController = UIStoryboard.login.initialViewController()
        if let rootAppViewController = source?.rootAppViewController() {
            rootAppViewController.display(destination)
        }
    }
}
