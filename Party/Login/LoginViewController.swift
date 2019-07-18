//
//  LoginViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, Alertable {
    
    // MARK: - UI Components
    
    @IBOutlet weak private var usernameTextField: IconTextField!
    
    @IBOutlet weak private var passwordTextField: IconTextField!
    
    // MARK: - Dependencies
    
    private var loginController: LoginController?
    
    private var secureStorage: SecureStorage!
    
    // MARK: - Lifecycle
    
    override func configureAfterInit() {
        secureStorage = SecureStorage()
        loginController = LoginController(source: self,
                                          secureStorage: secureStorage)
        loginController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preloadUserCredentials()
    }

    // MARK: - Actions
    
    @IBAction private func login(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        loginController?.startLogin(with: username, password: password)
    }
    
    // MARK: - Private Methods
    
    private func preloadUserCredentials() {
        usernameTextField.text = secureStorage.value(forKey: usernameKey)
        passwordTextField.text = secureStorage.value(forKey: passwordKey)
    }
}

// MARK: -

extension LoginViewController: LoginControllerDelegate {
    
    // MARK: - LoginControllerDelegate
    
    func loginControllerDidSuccessfullyLogin(_ loginController: LoginController) {
        performSegue(identifier: .showServerListViewController)
    }
    
    func loginController(_ loginController: LoginController, didFailWithError error: Error) {
        showErrorAlert(message: error.localizedDescription)
    }
}

// MARK: -

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = view.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
