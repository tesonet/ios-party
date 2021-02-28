//
//  MainFlowController.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import UIKit

class MainFlowController {
    let serviceFactory: ServiceFactory = .init()
    
    let rootViewController: UIViewController
    
    weak var listView: ServerListView?
    
    weak var currentViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let secureStorage = serviceFactory.secureStorageService
        if secureStorage.authToken != nil {
            showLoading()
        } else {
            showLogin()
        }
    }
    
    private func showLogin() {
        let loginView = LoginBuilder(factory: serviceFactory).view()
        loginView.onSuccess = { [weak self] in
            self?.showLoading()
        }
        
        rootViewController.transition(from: currentViewController, to: loginView.toPresent())
        currentViewController = loginView.toPresent()
    }
    
    private func showLoading() {
        let loadingView = ServerListFetchBuilder(factory: serviceFactory).view()
        loadingView.onSuccess = { [weak self] in
            self?.showList()
        }
        loadingView.onUnauthorized = { [weak self] in
            self?.start()
        }
        
        rootViewController.transition(from: currentViewController, to: loadingView.toPresent())
        currentViewController = loadingView.toPresent()
    }
    
    private func showList() {
        let listView = ServerListBuilder(factory: serviceFactory).view()
        listView.onLogout = { [weak self] in
            self?.start()
        }
        listView.onSelectSortOptions = { [weak self] in
            self?.showSortOptions()
        }

        let navController = ServerListNavigationController(rootViewController: listView.toPresent())
        rootViewController.transition(from: currentViewController, to: navController)
        
        self.listView = listView
        currentViewController = navController
    }
    
    private func showSortOptions() {
        let sortOptionsView = SortOptionsBuilder(factory: serviceFactory).view()
        sortOptionsView.onSelectOption = { [weak self] option in
            self?.listView?.didSelectSortOption(option)
        }
        
        let vc = listView?.toPresent()
        let actionSheet = sortOptionsView.toPresent()
        actionSheet.popoverPresentationController?.sourceView = (vc as? ServerListController)?.sortButton
        
        listView?.toPresent().present(actionSheet, animated: true, completion: nil)
    }
}
