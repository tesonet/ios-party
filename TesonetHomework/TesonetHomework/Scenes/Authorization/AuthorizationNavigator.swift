// Created by Paulius Cesekas on 02/04/2019.

import UIKit
import Domain

protocol AuthorizationNavigator: Navigatable {
    func navigateToLogin()
    func navigateToServerList()
}

class DefaultAuthorizationNavigator: AuthorizationNavigator {
    // MARK: - Variables
    private let useCaseProvider: UseCaseProvider
    
    // MARK: - Methods -
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigateToLogin() {
        let viewModel = LoginViewModel(with: useCaseProvider.makeAuthorizationUseCase())
        let viewController = LoginViewController.initialiaze(with: viewModel)
        rootNavigationController.isNavigationBarHidden = true
        rootNavigationController.setViewControllers(
            [viewController],
            animated: false)
    }
    
    func navigateToServerList() {
        let navigator = Application.shared.serversNavigator
        navigator.navigateToServerList(animated: false)
    }
}
