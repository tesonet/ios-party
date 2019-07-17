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
    
    // MARK: - Init
    
    init(source: UIViewController) {
        self.source = source
    }
    
    // MARK: - Public Methods
    
    func logout() {
        
        // clear user data
        
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
