//
//  LoginViewController.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(_ viewController: LoginViewController, token: String)
}

class LoginViewController: UIViewController, LoginFormViewDelegate {
    weak var delegate: LoginViewControllerDelegate?
    
    private let backgroundView = UIImageView(image: UIImage(named: "bg"))
    private let logoView = UIImageView(image: UIImage(named: "logo-white"))
    private let loginFormView = LoginFormView()
    
    private let loginManager: UserLoginManager
    
    init(loginManager: UserLoginManager) {
        self.loginManager = loginManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.contentMode = .scaleAspectFill
        self.logoView.contentMode = .center
        self.loginFormView.delegate = self
        
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.logoView)
        self.view.addSubview(self.loginFormView)
        
        self.makeConstriants()
    }
    
    private func makeConstriants() {
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.logoView.translatesAutoresizingMaskIntoConstraints = false
        self.loginFormView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.logoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.logoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.logoView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.logoView.bottomAnchor.constraint(equalTo: self.loginFormView.topAnchor).isActive = true
        
        self.loginFormView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3).isActive = true
        self.loginFormView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginFormView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    // MARK: - LoginFormViewDelegate
    
    func loginFormViewDidSelectLogin(_ view: LoginFormView, username: String, password: String) {
        self.loginManager.login(using: username, and: password) { (token, error) in
            if let token = token {
                self.handle(token: token)
            }
            
            if let error = error {
                self.handle(error: error)
            }
        }
    }
    
    // MARK: - Handlers
    
    private func handle(token: String) {
        self.delegate?.loginViewControllerDidLogin(self, token: token)
        self.loginFormView.clearFields()
    }
    
    private func handle(error: Error) {
        let alertController = UIAlertController(title: "Incorrect login or password", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
