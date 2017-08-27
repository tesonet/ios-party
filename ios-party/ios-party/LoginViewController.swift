//
//  LoginViewController.swift
//  ios-party
//
//  Created by Adomas on 10/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let authentication = Authentication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginButton.isEnabled = true
    }
    
    @IBAction func loginPressed() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        loginButton.isEnabled = false
        present(LoadingViewController(), animated: true) {
            self.authentication.login(username: username, password: password, completion: { success, message in
                if !success && message != nil {
                    self.presentAlert(withMessage: message!)
                } else if success {
                    self.getServerList()
                }
            })
        }
    }
    
    private func setupUI() {
        usernameContainerView.layer.cornerRadius = 2
        passwordContainerView.layer.cornerRadius = 2
        loginButton.layer.cornerRadius = 2
    }
    
    private func presentAlert(withMessage message: String) {
        navigationController?.dismiss(animated: true) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func getServerList() {
        let serversModel = ServerListModel()
        serversModel.getServerList() { servers, error in
            print(servers)
        }
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
