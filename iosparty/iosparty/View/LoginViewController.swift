//
//  ViewController.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, APIHandlerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
    }

//    @IBAction func clicked(_ sender: Any) {
//        let handler = APIHandler()
//        //handler.getToken(userName: "tesonet", password: "partyanimal")
//        handler.getServers(token: "f9731b590611a5a9377fbd02f247fcdf")
//    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else{
            return
        }
        let apiHandler = APIHandler(delegate: self)
        apiHandler.getToken(userName: username, password: password)
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
        let userNameImage = UIImage(named: "ico-username")
        userNameImageView.image = userNameImage
        
        let passwordImageView = UIImageView()
        let passwordImage = UIImage(named: "ico-lock")
        passwordImageView.image = passwordImage
        
        userNameIconView.image = userNameImage
        userNameOuterView.addSubview(userNameIconView)
        
        passwordIconView.image = passwordImage
        passwordOuterView.addSubview(passwordIconView)
        
        usernameTextField.leftView = userNameOuterView
        passwordTextField.leftView = passwordOuterView
    }
    
    func tokenReceived(response: AuthorizationResponse) {
        if response.success{
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        print(response.token)
    }
    
    func serversReceived(servers: [Server]) {
        return
    }
    
}

