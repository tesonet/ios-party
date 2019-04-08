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
        let useCase = useCaseProvider.makePlaygroundUseCase()
        let viewModel = ServerListViewModel(with: useCase)
        let viewController = ServerListViewController.initialiaze(with: viewModel)
        rootNavigationController.isNavigationBarHidden = false
        rootNavigationController.setViewControllers(
            [viewController],
            animated: animated)
    }
}
