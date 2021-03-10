//
//  Coordinator.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

enum CoordinatorStopReason {
    case logOut
    case error(String)
    case normalTermination
}

protocol CoordinatorProtocol: class {
    var onStop: ((CoordinatorStopReason) -> ())? { get set }
    var childCoordinator: CoordinatorProtocol? { get }
    var viewController: UIViewController? { get }
    var parentViewController: UIViewController { get }
    
    func start()
    func stop(reason: CoordinatorStopReason)
    func displayNextScreen()
    func displayMessage(_ message: String)
}

extension CoordinatorProtocol {
    func displayMessage(_ message: String) {
        let alertViewController = UIAlertController(title: LoginLocalization.Alert.title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LoginLocalization.Alert.ok, style: .default) { _ in
            alertViewController.dismiss(animated: true)
        }
        alertViewController.addAction(okAction)
        viewController?.present(alertViewController, animated: true)
    }
    
    func displayNextScreen() {}
}
