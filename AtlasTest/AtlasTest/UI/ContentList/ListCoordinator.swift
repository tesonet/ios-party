//
//  ListCoordinator.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

protocol ListCoordinator {
    init(dependency: DependencyContainer)
    func start()
}

class AppListCoordinator: ListCoordinator {
    unowned private var dependency: DependencyContainer
    private var loadingViewController: LoadingViewController?
    private var listViewController: ListViewController?
    private var listViewModel: ListViewModel?
    
    required init(dependency: DependencyContainer) {
        self.dependency = dependency
    }
    
    func start() {
        displayWaitingScreen()
        let listModel = AppListViewModel(dependency: dependency) { selectedServer in
            // Here we might process a server selection
        }
        listViewModel = listModel
        listViewController = AppListViewController.makeAppListViewController(viewModel: listModel) as? ListViewController
        listViewModel?.view = listViewController

        listViewModel?.updateServers() { [weak self] servers in
            DispatchQueue.main.async {
                guard let window = self?.dependency.window else { return }
                guard let listVC = self?.listViewController as? AppListViewController else { return }
                Transition.changeRootViewController(with: listVC, in: window, direction: .left)
            }
        }
    }
    
    func displayWaitingScreen() {
        guard let loadingViewController = LoadingViewController.makeLoadingViewController() else {  return }
        guard let window = dependency.window else { return }
        Transition.changeRootViewController(with: loadingViewController, in: window, direction: .up)
    }
    
    func displayList() {
        guard let window = dependency.window else { return }
        guard let listVC = listViewController as? AppListViewController else { return }
        Transition.changeRootViewController(with: listVC, in: window, direction: .left)
    }
    
    func onError(error: AppError) {
        dependency.errorHandler?.process(error: error)
    }
}
