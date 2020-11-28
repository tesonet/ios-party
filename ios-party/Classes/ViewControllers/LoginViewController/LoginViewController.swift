//
//  LoginViewController.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Constants
    private struct Constants {
        static let usernamePlaceholder = "Username"
        static let usernameImage = UIImage(named: "ico-username")
        static let passwordPlaceholder = "Password"
        static let passwordImage = UIImage(named: "ico-lock")
        
        static let loginButtonTitle = "Log in"
    }
    
    // MARK: - Declarations
    @IBOutlet private(set) weak var usernameTextField: ImageTextFieldView!
    @IBOutlet private(set) weak var passwordTextField: ImageTextFieldView!
    @IBOutlet private(set) weak var loginButton: UIButton!
    
    private var dataModel: LoginDataModel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel = LoginDataModel(delegate: self)
        
        setupUI()
    }
    
    func setupUI() {
        usernameTextField.setupUI(image: Constants.usernameImage,
                                  placeholder: Constants.usernamePlaceholder)
        passwordTextField.setupUI(image: Constants.passwordImage,
                                  placeholder: Constants.passwordPlaceholder,
                                  isPasswordEntry: true)
        
        loginButton.setTitle(Constants.loginButtonTitle, for: .normal)
    }
    
    @IBAction func onLoginButtonTap(_ sender: Any) {
        dataModel.login(withUsername: usernameTextField.text(),
                        password: passwordTextField.text())
    }
}
