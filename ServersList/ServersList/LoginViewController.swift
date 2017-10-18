//
//  LoginViewController.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 15/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, TesonetAPIDelegate {
    
    func authenticated(success: Bool) {
        if(success){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ServersListTableViewController") as! ServersListTableViewController
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            print("Write error of unauthenticated")
        }
    }

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        let api = TesonetAPI.sharedInstance
        api.delegate = self;
        api.authenticate(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
