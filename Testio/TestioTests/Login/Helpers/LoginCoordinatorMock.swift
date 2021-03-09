//
//  LoginCoordinatorMock.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/9/21.
//

import UIKit
@testable import Testio

final class LoginCoordinatorMock: CoordinatorProtocol {
    
    var onStop: (() -> ())?
    var childCoordinator: CoordinatorProtocol?
    var viewController: UIViewController?
    
    var onDisplayNextScreen: (() -> ())?
    var onDisplayMessage: (() -> ())?
    
    required init(with parentViewController: UIViewController) {}
    func start() {}
    func stop() {}
    
    func displayMessage(_ message: String) {
        onDisplayMessage?()
    }
    
    func displayNextScreen() {
        onDisplayNextScreen?()
    }
}
