//
//  AppFlowCoordinator.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class AppFlowCoordinator: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        startFlow()
    }
    
    func startFlow() {
        let loginViewController = LoginViewController(nibName: nil, bundle: nil)
        setViewControllers([loginViewController], animated: false)
    }
    
}
