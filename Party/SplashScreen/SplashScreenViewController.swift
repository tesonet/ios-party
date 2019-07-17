//
//  SplashScreenViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {
    
    // MARK: - Dependencies
    
    var tokenStorage: AuthTokenStorage!
    
    // MARK: - LifeCicle
    
    override func configureAfterInit() {
        tokenStorage = AuthTokenStorage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        perform()
    }
    
    // MARK: - Private methods
    
    private func perform() {
        guard tokenStorage.retrieve() != nil else {
            performSegue(identifier: .showLoginViewController)
            return
        }
        performSegue(identifier: .showServerListViewController)
    }

}
