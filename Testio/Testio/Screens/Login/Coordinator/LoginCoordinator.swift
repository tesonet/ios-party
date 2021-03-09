//
//  InfoListCoordinator.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

final class LoginCoordinator: CoordinatorProtocol {
    
    var viewController: UIViewController?
    let parentViewController: UIViewController
    var onStop: (() -> ())?
    private(set) var childCoordinator: CoordinatorProtocol?
    
    required init(with parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    func start() {
        let loginViewController = LogInViewController.instantiate()
        viewController = loginViewController
        let apiClient = ApiClient()
        let dataDecodingClient = DataDecodingClient()
        let dataDecodingService = AuthorizationDataDecodingService(client: dataDecodingClient)
        let loginService = LoginService(apiClient: apiClient, dataDecodingService: dataDecodingService)
        let viewModel = LoginViewModel(loginService: loginService, coordinator: self)
        loginViewController.viewModel = viewModel
        
        loginViewController.modalPresentationStyle = .fullScreen
        parentViewController.present(loginViewController, animated: false)
    }
    
    func stop() {
        onStop?()
    }
    
    func displayNextScreen() {
        //TODO: - display servers screen
    }
}

