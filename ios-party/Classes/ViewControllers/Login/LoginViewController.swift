//
//  LoginViewController.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

class LoginViewController: BaseViewController, LoginDataModelDelegate {

    // MARK: - Declarations
    var dataModel: LoginDataModelInterface!
    
    @IBOutlet weak var usernameTextField: ImageTextField!
    @IBOutlet weak var passwordTextField: ImageTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = LoginDataModel(delegate: self)
        
        usernameTextField.placeholder = R.string.localizable.username_placeholder()
        passwordTextField.placeholder = R.string.localizable.password_placeholder()
        loginButton.setTitle(R.string.localizable.login_action(), for: .normal)
    }
    
    // MARK: - UI Actions
    @IBAction func onLoginButtonTap(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
            return
        }
        
        hideKeyboard()
        dataModel.login(withUsername: username, password: password)
    }
    
    // MARK: - LoginDataModelDelegate
    func loginDataModel(didStartLogin dataModel: LoginDataModelInterface) {
        showActivityIndicator()
    }
    
    func loginDataModel(didFinishLogin dataModel: LoginDataModelInterface) {
        hideActivityIndicator()
    }
    
    func loginDataModel(didFailLogin dataModel: LoginDataModelInterface, errorType: LoginDataModel.ErrorType) {
        hideActivityIndicator()
        
        switch errorType {
        case .authorizationError:
            showAlert(title: R.string.localizable.wrong_credentials_title(),
                      message: R.string.localizable.wrong_credentials_description())
            
        default:
            showAlert(title: R.string.localizable.generic_error_title(),
                      message: R.string.localizable.generic_error_description())
        }
    }
    
    // MARK: - Keyboard
    func hideKeyboard() {
        view.endEditing(true)
    }
}
