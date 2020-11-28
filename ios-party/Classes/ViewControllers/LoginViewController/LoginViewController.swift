//
//  LoginViewController.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private(set) weak var usernameTextField: ImageTextFieldView!
    @IBOutlet private(set) weak var passwordTextField: ImageTextFieldView!
    @IBOutlet private(set) weak var loginButton: UIButton!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        usernameTextField.setupUI(image: UIImage(named: "ico-username"), placeholder: "Username")
        passwordTextField.setupUI(image: UIImage(named: "ico-lock"), placeholder: "Password", isPasswordEntry: true)
        
        loginButton.setTitle("Log in", for: .normal)
    }
}
