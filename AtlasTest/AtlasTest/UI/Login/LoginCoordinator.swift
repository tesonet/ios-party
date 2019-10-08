//
//  LoginCoordinator.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

protocol LoginCoordinator {
    init(dependency: DependencyContainer, completionHandler: @escaping ((Bool) -> Void))
    func start()
}

class AppLoginCoordinator: LoginCoordinator {
    unowned private var dependency: DependencyContainer
    private var loadingViewController: LoadingViewController?
    private var loginViewController: LoginViewController?
    private var loginViewModel: LoginViewModel?
    private var completionHandler: ((Bool) -> Void)
    
    required init(dependency: DependencyContainer, completionHandler: @escaping ((Bool) -> Void)) {
        self.dependency = dependency
        self.completionHandler = completionHandler
    }
    
    func start() {
        let loginModel = AppLoginViewModel(dependency: dependency, completionHandler: onLoggedIn)
        loginViewModel = loginModel
        loginViewController = AppLoginViewController.makeLoginViewController(viewModel: loginModel) as? LoginViewController
        loginViewModel?.view = loginViewController
        displayLogin()
    }
    
    func displayLogin() {
        guard let loginVC = loginViewController as? UIViewController else { return }
        guard let window = dependency.window else { return }
        cleanData()
        Transition.changeRootViewController(with: loginVC, in: window, direction: .up)
    }
    
    func displayWaitingScreen() {
        guard let loadingViewController = LoadingViewController.makeLoadingViewController() else {  return }
        guard let window = dependency.window else { return }
        Transition.changeRootViewController(with: loadingViewController, in: window, direction: .up)
    }
    
    func onLoggedIn(state: Bool) {
        if state {
            displayWaitingScreen()
        }
        completionHandler(state)
    }
    
    func onError(error: AppError) {
        dependency.errorHandler?.process(error: error)
    }
}

private extension AppLoginCoordinator {
    func cleanData() {
        LocalStorage.deleteToken()
        LocalStorage.deleteUserCredentials()
        dependency.dataManager?.deleteServers()
    }
}
