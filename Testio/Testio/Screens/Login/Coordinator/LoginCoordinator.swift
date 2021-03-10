//
//  InfoListCoordinator.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

protocol LoginCoordinatorProtocol: CoordinatorProtocol {
    func displayNextScreen(with authorizationData: AuthorizationData)
}

final class LoginCoordinator: LoginCoordinatorProtocol  {
    
    var viewController: UIViewController?
    let parentViewController: UIViewController
    var onStop: ((CoordinatorStopReason) -> ())?
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
    
    func stop(reason :CoordinatorStopReason) {
        onStop?(reason)
    }
    
    func displayNextScreen(with authorizationData: AuthorizationData) {
        let serversListCoordinator = ServersListCoordinator(with: viewController ?? parentViewController, authorizationData: authorizationData)
        childCoordinator = serversListCoordinator
        serversListCoordinator.onStop = { reason in
            switch reason {
            case .error(let description):
                self.displayMessage(description)
            default:
                break
            }
            self.childCoordinator = nil
        }
        serversListCoordinator.start()
    }
}

