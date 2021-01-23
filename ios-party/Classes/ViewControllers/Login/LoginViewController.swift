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
    
    @IBOutlet weak var emailTextField: ImageTextField!
    @IBOutlet weak var passwordTextField: ImageTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = LoginDataModel(delegate: self)
    }
    
    // MARK: - UI Actions
    @IBAction func onLoginButtonTap(_ sender: Any) {
        guard let username = emailTextField.text,
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
    
    func loginDataModel(didFailLogin dataModel: LoginDataModelInterface) {
        // FIXME: show error
        hideActivityIndicator()
    }
    
    // MARK: - Keyboard
    func hideKeyboard() {
        view.endEditing(true)
    }
}
