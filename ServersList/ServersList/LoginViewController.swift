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
    
    var tesonetApi: TesonetAPI = TesonetAPI.sharedInstance;
    
    var customModalViewController: UIViewController? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing UI elements
        self.initUsernameTextField()
        self.initPasswordTextField()
        
        tesonetApi.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        tesonetApi.authenticate(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    /*
     * Initialize username text field
     */
    func initUsernameTextField(){
        self.usernameTextField.addIcon(icon: UIImage(named: "ico-username")!)
        self.usernameTextField.addPlaceholder(placeholder: "Username")
    }
    
    /*
     * Initialize password text field
     */
    func initPasswordTextField(){
        self.passwordTextField.addIcon(icon: UIImage(named: "ico-lock")!)
        self.passwordTextField.addPlaceholder(placeholder: "Password")
        self.passwordTextField.isSecureTextEntry = true
    }
    
    // MARK: - API Delegate
    func authenticated(success: Bool) {
        if(success){
            self.customModalViewController = (
                storyboard?.instantiateViewController(
                    withIdentifier: "loadingViewController")
                )!
            
            self.customModalViewController?.modalTransitionStyle = .crossDissolve
            present(self.customModalViewController!, animated: true, completion: nil)
            
            tesonetApi.getServers()
        } else {
            print("TODO: Write error of unauthenticated")
        }
    }
    
    func downloadedInfo(info: NSArray) {
        var servers = [Server]()
        
        for server in info{
            if let serverDictionary = server as? NSDictionary{
                servers.append(Server(name: serverDictionary.object(forKey: "name") as! String, distance:serverDictionary.object(forKey: "distance") as! Int ))
            }
        }
        
        self.customModalViewController?.dismiss(animated: false, completion: {
            //Loading servers tableviewcontroller
            let nextViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "ServersListViewController") as! ServersListViewController
            
            nextViewController.servers = servers
            self.present(nextViewController, animated:true, completion:nil)
        })
    }
}
