//
//  LoginViewController.swift
//  Servers
//
//  Created by Rimantas Lukosevicius on 10/06/2018.
//  Copyright © 2018 Rimantas Lukosevicius. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.usernameTextField.leftViewMode = .always
        self.usernameTextField.leftView =
            UIImageView.init(frame: CGRect(x: 0.0, y: 0.0,
                                           width: self.usernameTextField.bounds.size.height,
                                           height: self.usernameTextField.bounds.size.height))
        (self.usernameTextField.leftView as! UIImageView).image = UIImage(named: "ico-username")
        self.usernameTextField.leftView?.contentMode = .center
        
        self.passwordTextField.leftViewMode = .always
        self.passwordTextField.leftView =
            UIImageView(frame: CGRect(x: 0.0, y: 0.0,
                                      width: self.passwordTextField.bounds.size.height,
                                      height: self.passwordTextField.bounds.size.height))
        (self.passwordTextField.leftView as! UIImageView).image = UIImage(named: "ico-lock")
        self.passwordTextField.leftView?.contentMode = .center
        
        self.loginButton.layer.cornerRadius = 4.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if APIClient.shared.hasToken() {
            return
        }
        
        let (success, username, password) = KeychainHelper().getCredentials()
        
        if success && username != nil && password != nil {
            self.usernameTextField.text = username
            self.passwordTextField.text = password
            
            self.buttonTapped(self.loginButton)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.usernameTextField.text = nil
        self.passwordTextField.text = nil
        
        super.viewWillDisappear(animated)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let username = self.usernameTextField.text else {
            return
        }
        
        guard let password = self.passwordTextField.text else {
            return
        }
        
        if username.count == 0 || password.count == 0 {
            return
        }
        
        loginSpinner.startAnimating()
        loginButton.setTitle("", for: .normal)
        
        APIClient.shared.obtainTokenWith(username: username,
                                         password: password) { (success) in
                                            DispatchQueue.main.async {
                                                self.loginSpinner.stopAnimating()
                                                self.loginButton.setTitle("Log In", for: .normal)
                                                
                                                if success {
                                                    _ = KeychainHelper().saveCredentials(username: username, password: password)
                                                    self.performSegue(withIdentifier: "fetch", sender: nil)
                                                }
                                            }
        }
    }
}
