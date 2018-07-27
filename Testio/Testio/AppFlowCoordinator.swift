//
//  AppFlowCoordinator.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

class AppFlowCoordinator: UINavigationController {

    private let networkService = TestioNetworkService()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        
        UIView.appearance().tintColor = Colors.actionColor
        startFlow()
    }
    
    func startFlow() {
        let loginViewModel = LoginViewModel(authorizationPerformer: networkService)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.bindViewModel()
        setViewControllers([loginViewController], animated: false)
    }
    
}
