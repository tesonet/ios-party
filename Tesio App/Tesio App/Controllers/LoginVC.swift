//
//  LoginVC.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Enums
    enum Strings {
        static let serversListIdentifier = "serversListIdentifier"
    }
    
    // MARK: - Vars
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = "tesonet"
        passwordTextField.text = "partyanimal"
    }

    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            API.loginWith(username: username, password: password) { (token, error) in
                
                guard let error = error else {
                    guard let token = token else { return }
                    TesioHelper.setLogin(token: token)
                    self.goToServersList()
                    return
                }
                
                print("Login failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Methods
    
    func goToServersList() {
        if let listController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Strings.serversListIdentifier) as? ServersListTVC {
            let navigationController = UINavigationController(rootViewController: listController)
            present(navigationController, animated: true, completion: nil)
        }
    }

}


// Mark: Class extensions

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
}

