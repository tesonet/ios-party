//
//  LoginCoordinatorMock.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/9/21.
//

import UIKit
@testable import Testio

final class LoginCoordinatorMock: LoginCoordinatorProtocol {
   
    var parentViewController: UIViewController
    var onStop: (() -> ())?
    var childCoordinator: CoordinatorProtocol?
    var viewController: UIViewController?
    
    var onDisplayNextScreen: (() -> ())?
    var onDisplayMessage: (() -> ())?
    
    init(with parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    func start() {}
    func stop() {}
    
    func displayMessage(_ message: String) {
        onDisplayMessage?()
    }
    
    func displayNextScreen(with authorizationData: AuthorizationData) {
        onDisplayNextScreen?()
    }
}
