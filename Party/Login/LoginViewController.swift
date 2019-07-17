//
//  LoginViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    @IBOutlet weak private var usernameTextField: IconTextField!
    
    @IBOutlet weak private var passwordTextField: IconTextField!
    
    // MARK: - Dependencies
    
    private var loginController: LoginController?
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureAfterInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureAfterInit()
    }

    // MARK: - Actions
    
    @IBAction private func login(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        loginController?.startLogin(with: username, password: password)
    }
    
    // MARK: - Private methods
    
    private func configureAfterInit() {
        loginController = LoginController(source: self, delegate: self)
    }
}

// MARK: -

extension LoginViewController: LoginControllerDelegate {
    
    // MARK: - LoginControllerDelegate
    
    func loginControllerDidSuccessfullyLogin(_ loginController: LoginController) {
        
    }
    
    func loginController(_ loginController: LoginController, didFailWithError error: Error) {
        
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
