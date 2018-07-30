//
//  LoginVC.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

typealias LoginCompletion = ([Server]?) -> ()

class LoginVC: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - Outlets
    @IBOutlet weak var loginElementsStackView: UIStackView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Enums
    enum Strings {
        static let loginText = "Login in..."
        static let authorizationText = "Authenticating..."
    }
    
    // MARK: - Vars
    let sizeOfLoadingIndicator = CGSize(width: 50, height: 50)
    open var onLoginCompletion: LoginCompletion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.text = "tesonet"
        passwordTextField.text = "partyanimal"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginViewAppearanceAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideElements()
    }

    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }
    
    // MARK: - Methods
    func login() {

        // Start loading animation
        startAnimating(sizeOfLoadingIndicator, message: Strings.loginText, type: .orbit, fadeInAnimation: nil)
        
        if let username = usernameTextField.text, username != "", let password = passwordTextField.text, password != "" {
            
            API.loginWith(username: username, password: password) { (servers, error) in
                guard let loginError = error else {
                    // Save usercrediantials to keychain
                    TesioHelper.setUserCrediantials(username: username, password: password)
                    
                    if let servers = servers, servers.count > 0 {
                        // Wait some time to indicate fetching (cuz in our case it's very fast)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            NVActivityIndicatorPresenter.sharedInstance.setMessage(Strings.authorizationText)
                        }
                        // Same as with "Login in", wait and imitate Authentication & go to Servers listview
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                            self.stopAnimating(nil)
                            TesioHelper.isAuthorized = true
                            self.onLoginCompletion?(servers)
                        }
                    }
                    return
                }
                
                switch loginError {
                    case .AuthorizationFailed: TesioHelper.showBasicAler(title: TesioHelper.LoginError.AuthorizationFailed.title,
                                                                         message: TesioHelper.LoginError.AuthorizationFailed.description, vc: self)
                    default: TesioHelper.showBasicAler(title: TesioHelper.LoginError.Other.title,
                                                       message: TesioHelper.LoginError.Other.description, vc: self)
                }
                
                self.stopAnimating(nil)
            }
        }
        else {
            stopAnimating(nil)
            if usernameTextField.text == nil || usernameTextField.text == "" {
                TesioHelper.showBasicAler(title: TesioHelper.LoginError.EmptyUsername.title,
                                          message: TesioHelper.LoginError.EmptyUsername.description, vc: self)
            }
            else if passwordTextField.text == nil || passwordTextField.text == "" {
                TesioHelper.showBasicAler(title: TesioHelper.LoginError.EmptyPassword.title,
                                          message: TesioHelper.LoginError.EmptyPassword.description, vc: self)
            }
        }
    }

}


// Mark: Class extensions

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder && usernameTextField.text != "" {
            passwordTextField.becomeFirstResponder()
        }
        else if passwordTextField.isFirstResponder && passwordTextField.text != "" {
            passwordTextField.resignFirstResponder()
            login()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension LoginVC {
    
    func hideElements() {
        logo.alpha = 0
        logo.center.y += 20
        loginElementsStackView.alpha = 0
        loginElementsStackView.center.y += 20
    }
    
    func loginViewAppearanceAnimation() {
        hideElements()
        elementsFadeInAnimation()
    }
    
    func elementsFadeInAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.loginElementsStackView.alpha = 1
            self.loginElementsStackView.center.y -= 20
        }
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.logo.alpha = 1
            self.logo.center.y -= 20
        }, completion: nil)
    }
}






