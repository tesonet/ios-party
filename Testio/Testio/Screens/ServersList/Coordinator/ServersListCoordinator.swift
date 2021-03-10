//
//  InfoListCoordinator.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

protocol ServersListCoordinatorProtocol: CoordinatorProtocol {
    func displaySortingOptions(_ options: [SortingOption], completion: @escaping (SortingOption) -> ())
}

final class ServersListCoordinator: ServersListCoordinatorProtocol {
    
    var viewController: UIViewController?
    let parentViewController: UIViewController
    var onStop: ((CoordinatorStopReason) -> ())?
    
    private(set) var childCoordinator: CoordinatorProtocol?
    private let authorizationData: AuthorizationData
    
    init(with parentViewController: UIViewController, authorizationData: AuthorizationData) {
        self.parentViewController = parentViewController
        self.authorizationData = authorizationData
    }
    
    func start() {
        let serversListViewController = ServersListViewController.instantiate()
        viewController = serversListViewController
        let apiClient = ApiClient()
        let dataDecodingClient = DataDecodingClient()
        let dataDecodingService = ServersListDataDecodingService(client: dataDecodingClient)
        let fetchingService = ServersListService(apiClient: apiClient, dataDecodingService: dataDecodingService)
        let sortingService = ServersListSortingService()
        let model = ServersListModel(authorizationData: authorizationData)
        let viewModel = ServersListViewModel(model: model, coordinator: self, fetchingService: fetchingService, sortingService: sortingService)
        serversListViewController.viewModel = viewModel

        serversListViewController.modalPresentationStyle = .fullScreen
        serversListViewController.modalTransitionStyle = .crossDissolve
        parentViewController.present(serversListViewController, animated: true)
    }
    
    func stop(reason: CoordinatorStopReason) {
        viewController?.dismiss(animated: true, completion: {
            self.onStop?(reason)
        })
    }
    
    func displaySortingOptions(_ options: [SortingOption], completion: @escaping (SortingOption) -> ()) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        options.forEach { sortingOption in
            let action = UIAlertAction(title: sortingOption.title, style: .default) { _ in
                completion(sortingOption)
            }
            actionSheetController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelAction)
        viewController?.show(actionSheetController, sender: nil)
    }
}

