//
//  LoginViewController.swift
//  GreatiOSApp
//
//  Created by Domas on 4/6/17.
//  Copyright © 2017 Sonic Team. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: LoginScreenTextField!
    @IBOutlet weak var passwordTextField: LoginScreenTextField!
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var loadingView: SpinnerView!
    @IBOutlet weak var loadingLabel: UILabel!
    let userNameKey = "userNameKey"
    let userPasswordKey = "userPasswordKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.loadCredentialsFromKeychain()
    }
    
    func loadCredentialsFromKeychain() {
        if let username = KeychainService.loadWithKey(userNameKey as NSString) {
            self.usernameTextField.text = username as String
        }
        if let password = KeychainService.loadWithKey(userPasswordKey as NSString) {
            self.passwordTextField.text = password as String
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.logoImageView.alpha = 1.0
        self.usernameTextField.alpha = 1.0
        self.passwordTextField.alpha = 1.0
        self.loginButton.alpha = 1.0
        self.loadingLabel.alpha = 0.0
        self.loadingView.alpha = 0.0
        loadingView.layer.removeAllAnimations()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.login()
    }
    
    private func login() {
        let parameters: Parameters = ["username": usernameTextField.text!,
                                      "password": passwordTextField.text!]
        Alamofire.request("http://playground.tesonet.lt/v1/tokens", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let result = response.result.value {
                    let json = result as! Dictionary<String, String>
                    if let token = json["token"] {
                        self.startLoadingAnimation()
                        self.getDataListWithToken(token)
                    }
                    if let message = json["message"] {
                        print(message)
                    }
                }
        }
    }
    
    private func getDataListWithToken(_ token: String) {
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
        Alamofire.request("http://playground.tesonet.lt/v1/servers", headers: headers).responseJSON { response in
            if let result = response.result.value {
                let when = DispatchTime.now() + 3
                KeychainService.saveWithKey(self.userNameKey as NSString, token: self.usernameTextField.text! as NSString)
                KeychainService.saveWithKey(self.userPasswordKey as NSString, token: self.passwordTextField.text! as NSString)
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.performSegue(withIdentifier: "listSegue", sender: self.getDataFromResult(result))
                }
            }
        }
    }
    
    private func getDataFromResult(_ result: Any) -> Array<DataItem> {
        var dataArray: [DataItem] = []
        let json = result as! Array<Dictionary<String, Any>>
        for item in json {
            let dataItem = DataItem(dataWithDictionary: item)
            dataArray.append(dataItem)
        }
        return dataArray
    }
    
    private func removeAnimations() {
        loadingView.stopAnimation()
        loadingLabel.layer.removeAllAnimations()
    }
    
    private func startLoadingAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            self.logoImageView.alpha = 0.0
            self.usernameTextField.alpha = 0.0
            self.passwordTextField.alpha = 0.0
            self.loginButton.alpha = 0.0
        }, completion: {
            finished in
            self.loadingView.startAnimation()
            UIView.animate(withDuration: 1.0, animations: {
                self.loadingView.alpha = 1.0
                self.loadingLabel.alpha = 1.0
            })
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "listSegue") {
     //       let navVC = segue.destination as? UINavigationController
            let vc = segue.destination as! DataListViewController
            vc.data = sender as! Array<DataItem>
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
