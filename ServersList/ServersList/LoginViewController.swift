//
//  LoginViewController.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 15/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, TesonetAPIDelegate {
    
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var submitButton: LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing UI elements
        self.initUsernameTextField()
        self.initPasswordTextField()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUsernameTextField(){
        self.usernameTextField.addIcon(icon: UIImage(named: "ico-username")!)
        self.usernameTextField.addPlaceholder(placeholder: "Username")
    }
    
    func initPasswordTextField(){
        self.passwordTextField.addIcon(icon: UIImage(named: "ico-lock")!)
        self.passwordTextField.addPlaceholder(placeholder: "Password")
        self.passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let api = TesonetAPI.sharedInstance
        api.delegate = self;
        api.authenticate(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    // MARK: - API Delegate
    func authenticated(success: Bool) {
        if(success){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ServersListViewController") as! ServersListViewController
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            print("TODO: Write error of unauthenticated")
        }
    }
}
