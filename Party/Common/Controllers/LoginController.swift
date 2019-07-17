//
//  LoginController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

protocol LoginControllerDelegate: class {
    
    func loginControllerDidSuccessfullyLogin(_ loginController: LoginController)
    
    func loginController(_ loginController: LoginController, didFailWithError error: Error)
}

class LoginController {
    
    // MARK: - Dependencies
    
    /// A client used to authenticate user.
    lazy var authClient: AuthClient = {
        AuthClient(baseUrl: Backend.baseUrl)
    }()
    
    // token storage for auth token
    
    // keychain storage for password
    
    weak var source: UIViewController?
    
    // MARK: - States
    
    weak var delegate: LoginControllerDelegate?
    
    /// Indicates if login request is already in progress.
    private(set) var isLoading: Bool = false
    
    // MARK: - Init
    
    init(source: UIViewController, delegate: LoginControllerDelegate) {
        self.source = source
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    /// Starts login process.
    ///
    /// - Parameters:
    ///   - username: A user typed text.
    ///   - password: A user typed text.
    func startLogin(with username: String, password: String) {
        guard isLoading == false else {
            // tried to login when already in progress.
            return
        }
        isLoading = true
        
        authClient.authenticate(with: username, password: password) { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.handleSuccessfulAuthentication(with: token)
            case .failure(let error):
                self?.handleFailure(with: error)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Handles successful response.
    ///
    /// - Parameter token: A access token.
    private func handleSuccessfulAuthentication(with token: String) {
        isLoading = false
        // store token
        
        delegate?.loginControllerDidSuccessfullyLogin(self)
    }
    
    /// Handles failed request.
    ///
    /// - Parameter error: A error that needs to be handled.
    private func handleFailure(with error: Error) {
        isLoading = false
        delegate?.loginController(self, didFailWithError: error)
    }
}
