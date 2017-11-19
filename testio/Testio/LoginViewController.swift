//
//  LoginViewController.swift
//  testio
//
//  Created by Karolis Misiūra on 18/11/2017.
//  Copyright © 2017 Karolis Misiura. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    static let KeychainTokenKey = "TokenKey"
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = UIColor.clear
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var userNameField: UITextField = {
        let nameField = TextFieldWithInsets(frame: CGRect.zero)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.autocorrectionType = UITextAutocorrectionType.no
        nameField.autocapitalizationType = UITextAutocapitalizationType.none
        nameField.background = #imageLiteral(resourceName: "TextFieldBackground")
        nameField.placeholder = "Username"
        nameField.textPadding = UIEdgeInsets(top: 0.0, left: 32.0, bottom: 0.0, right: 8.0)
        nameField.leftViewMode = UITextFieldViewMode.always
        let leftView = UIImageView(image: #imageLiteral(resourceName: "ico-username"))
        nameField.leftView = leftView
        
        return nameField
    }()
    
    private lazy var passwordField: UITextField = {
        let passwordField = TextFieldWithInsets(frame: CGRect.zero)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.autocapitalizationType = UITextAutocapitalizationType.none
        passwordField.isSecureTextEntry = true
        passwordField.background = #imageLiteral(resourceName: "TextFieldBackground")
        passwordField.placeholder = "Password"
        passwordField.textPadding = UIEdgeInsets(top: 0.0, left: 32.0, bottom: 0.0, right: 8.0)
        passwordField.leftViewMode = UITextFieldViewMode.always
        let leftView = UIImageView(image: #imageLiteral(resourceName: "ico-lock"))
        passwordField.leftView = leftView
        
        return passwordField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "ButtonBackground"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(loginAction(_:)), for: UIControlEvents.touchUpInside)
        button.setTitle("Login", for: UIControlState.normal)
        
        return button
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.view.addSubview(self.scrollView)
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.scrollView.addSubview(self.userNameField)
        self.userNameField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10.0).isActive = true
        self.userNameField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.userNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userNameField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.scrollView.addSubview(self.passwordField)
        self.passwordField.topAnchor.constraint(equalTo: self.userNameField.bottomAnchor, constant: 10.0).isActive = true
        self.passwordField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.scrollView.addSubview(self.loginButton)
        self.loginButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 10.0).isActive = true
        self.loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.scrollView.addSubview(self.spinner)
        self.spinner.centerXAnchor.constraint(equalTo: self.loginButton.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: self.loginButton.centerYAnchor).isActive = true
        
        self.loginButton.isEnabled = false
        
        let keyChain = KeychainSwift()
        if let token = keyChain.get(LoginViewController.KeychainTokenKey) {
            let serversVC = ServersViewController()
            serversVC.accessToken = token
            self.present(UINavigationController(rootViewController: serversVC), animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self.userNameField)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self.passwordField)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func handleLogin(error: Error) {
        if let error = error as? APIError {
            if error == APIError.unauthorized {
                let errorMessage = UIAlertController(title: "Login Error", message: "Wrong username or password.", preferredStyle: UIAlertControllerStyle.alert)
                errorMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(errorMessage, animated: true, completion: nil)
            } else {
                let errorMessage = UIAlertController(title: "Login Error", message: "There was a problem with server. Try again later or contact support.", preferredStyle: UIAlertControllerStyle.alert)
                errorMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(errorMessage, animated: true, completion: nil)
            }
        } else {
            let errorMessage = UIAlertController(title: "Login Error", message: "There was a problem with server. Try again later or contact support.", preferredStyle: UIAlertControllerStyle.alert)
            errorMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(errorMessage, animated: true, completion: nil)
        }
    }
    
    @objc func textFieldDidChange(notification: Notification) {
        self.loginButton.isEnabled = (self.userNameField.text?.isEmpty == false && self.passwordField.text?.isEmpty == false)
    }
    
    @objc func loginAction(_ sender: Any?) {
        guard let name = self.userNameField.text, let password = self.passwordField.text else {
            return
        }
        
        self.loginButton.isHidden = true
        self.spinner.startAnimating()
        
        API.login(username: name, password: password, completion: { (error, token) in
            
            self.userNameField.text = ""
            self.passwordField.text = ""
            
            self.loginButton.isHidden = false
            self.spinner.stopAnimating()
            
            if let error = error {
                self.handleLogin(error: error)
            } else if let token = token {
                let keychain = KeychainSwift()
                keychain.set(token, forKey: LoginViewController.KeychainTokenKey)
                
                let serversVC = ServersViewController()
                serversVC.accessToken = token
                self.present(UINavigationController(rootViewController: serversVC), animated: true, completion: nil)
            }

        })
    }
}

