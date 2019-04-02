// Created by Paulius Cesekas on 02/04/2019.

import UIKit
import Domain

protocol ServersNavigator: Navigatable {
    func navigateToServerList(animated: Bool)
}

class DefaultServersNavigator: ServersNavigator {
    // MARK: - Variables
    private let useCaseProvider: UseCaseProvider
    
    // MARK: - Methods -
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigateToServerList(animated: Bool) {
//        let viewModel = LoginViewModel(with: useCaseProvider.makeAuthorizationUseCase())
        let viewController = ServerListViewController()//LoginViewController.initialiaze(with: viewModel)
        rootNavigationController.setNavigationBarHidden(
            false,
            animated: animated)
        rootNavigationController.setViewControllers(
            [viewController],
            animated: animated)
    }
}
