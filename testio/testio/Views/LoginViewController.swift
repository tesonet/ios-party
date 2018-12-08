//
//  LoginViewController.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 06/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginFormStackView: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateContent()
        
        animateContent(appear: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animateContent(appear: false)
    }
    
    private func setup() {
        usernameTextField.placeholder = Strings.LoginVC.usernamePlaceholder.localized
        passwordTextField.placeholder = Strings.LoginVC.passwordPlaceholder.localized
        loginButton.setTitle(Strings.LoginVC.loginButtonTitle.localized, for: .normal)
        let usernameImage = UIImageView(image: #imageLiteral(resourceName: "ico-username"))
        if let size = usernameImage.image?.size {
            usernameImage.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 15.0, height: 10)
        }
        usernameImage.contentMode = .scaleAspectFit
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = usernameImage
        
        let passwordImage = UIImageView(image: #imageLiteral(resourceName: "ico-lock"))
        if let size = passwordImage.image?.size {
            passwordImage.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 15.0, height: 10)
        }
        passwordImage.contentMode = .scaleAspectFit
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = passwordImage
    }
    
    private func animateContent(appear: Bool) {
        // Animate login content appearance
        UIView.animate(withDuration: Const.standardAnimationDuration) { [weak self] in
            self?.logoImageView.alpha = appear ? 1 : 0
            self?.loginFormStackView.alpha = appear ? 1 : 0
        }
    }
    
    private func updateContent() {
        // clean up login form
        usernameTextField.text = nil
        passwordTextField.text = nil
        loginButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func doLogIn() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            presentAlert(withTitle: Strings.Error.localized, message: Strings.LoginVC.usernameEmpty.localized)
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(withTitle: Strings.Error.localized, message: Strings.LoginVC.passwordEmpty.localized)
            return
        }
        
        loginButton.isEnabled = false
        
        TesonetAPI.login(LoginRequest(username: username, password: password))
            .request(caller: self, onSuccess: {[weak self] (result: LoginResult, _) in
                try? User.authorized(User.Auth(username: username, password: password, token: result.token))
                LoadingView.shared?.start()
                self?.loadServers() {
                    LoadingView.shared?.stop()
                    Notification.loggedIn.post()
                }
            }, onError: {[weak self] (_,msg,_) in
                self?.loginButton.isEnabled = true
                self?.presentAlert(withTitle: Strings.Error.localized, message: msg ?? Strings.LoginVC.loginFailed.localized)
            })
    }
    
    private func loadServers(onSuccess: @escaping () -> ()) {
        // TODO: present loading view
        
        TesonetAPI.getServers.request(caller: self, onSuccess: { (results: [ServerResult], _) in
            PersistentContainer.shared.deleteAll(withRequest: Server.fetchRequest())
            for result in results {
                let server = Server.init(entity: Server.entity(), insertInto: PersistentContainer.shared.context)
                server.name = result.name
                server.distance = Int64(result.distance)
            }
            PersistentContainer.shared.saveContext()
            
            onSuccess()
        })
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            doLogIn()
        }
        return true
    }
}
