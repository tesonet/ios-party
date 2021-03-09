//
//  Coordinator.swift
//  TestProject
//
//  Created by Andrii Popov on 2/22/21.
//

import UIKit

protocol CoordinatorProtocol: class {
    var onStop: (() -> ())? { get set }
    var childCoordinator: CoordinatorProtocol? { get }
    var viewController: UIViewController? { get }
    
    init(with parentViewController: UIViewController)
    func start()
    func stop()
    func displayNextScreen()
    func displayMessage(_ message: String)
}

extension CoordinatorProtocol {
    func displayMessage(_ message: String) {
        let alertViewController = UIAlertController(title: Localization.Alert.title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localization.Alert.ok, style: .default) { _ in
            alertViewController.dismiss(animated: true)
        }
        alertViewController.addAction(okAction)
        viewController?.present(alertViewController, animated: true)
    }
}
