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
        
        APIClient.shared.obtainTokenWith(username: username,
                                         password: password) { (success) in
                                            if success {
                                                DispatchQueue.main.async {
                                                    self.performSegue(withIdentifier: "fetch", sender: nil)
                                                }
                                            }
        }
    }
}
