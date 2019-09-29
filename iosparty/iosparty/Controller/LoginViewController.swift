//
//  ViewController.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.text = ""
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        performSegue(withIdentifier: Constants.LOGIN_SEGUE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.LOGIN_SEGUE) {
            guard let username = usernameTextField.text, let password = passwordTextField.text else{
                return
            }
            let vc = segue.destination as! LoadingViewController
            vc.userName = username
            vc.password = password
        }
    }
    
    private func setupUIElements(){
        logInButton.layer.cornerRadius = 5
        usernameTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        
        let padding = 26
        let size = 16
        let userNameOuterView = UIView(frame: CGRect(x: 0, y: 0, width: size + padding, height: size))
        let userNameIconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        let passwordOuterView = UIView(frame: CGRect(x: 0, y: 0, width: size + padding, height: size))
        let passwordIconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))

        let userNameImageView = UIImageView()
        let userNameImage = UIImage(named: Constants.USER_NAME_ICON)
        userNameImageView.image = userNameImage
        
        let passwordImageView = UIImageView()
        let passwordImage = UIImage(named: Constants.LOCK_ICON)
        passwordImageView.image = passwordImage
        
        userNameIconView.image = userNameImage
        userNameOuterView.addSubview(userNameIconView)
        
        passwordIconView.image = passwordImage
        passwordOuterView.addSubview(passwordIconView)
        
        usernameTextField.leftView = userNameOuterView
        passwordTextField.leftView = passwordOuterView
    }
    
    
}

