//
//  ViewController.swift
//  iOS-PARTY
//
//  Created by Abhishek Biswas on 15/01/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    
    var spinnerView : SpinnerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameView.layer.cornerRadius = 10
        self.passwordView.layer.cornerRadius = 10
        self.buttonLogin.layer.cornerRadius = 10
        self.buttonLogin.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        prepForSetup()
        self.loadingView.isHidden = true
    }
    
    func prepForSetup() {
        spinnerView = SpinnerView()
        spinnerView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        self.loadingView.addSubview(spinnerView)
        spinnerView.center = loadingView.center
    }
    
    
    @objc func buttonAction(_ sender: UIButton) {
        guard let userTxt = self.userNameTextField.text, let passTxt = self.passwordTextField.text else {return}
        if !userTxt.isEmpty && !passTxt.isEmpty {
            self.loadingView.isHidden = false
            self.buttonLogin.isHidden = true
            spinnerView.animate()
            let finalUrl : String = Constants.baseUrl + Constants.tokenEndpoint
            NetworkManager.shared.makeAPICall(withUrlString: finalUrl, withMethod: "POST", withUserName: userTxt, withPassword: passTxt ,isHeader: false, header: [:]) { responseDict in
                guard let response = responseDict else {return}
                if response.statusCode == 200 {
                    if let barrerToken = response.responseDict?["token"] as? String {
                        UserDefaults.standard.setValue(barrerToken, forKey: "bearer")
                        DispatchQueue.main.async {
                            self.spinnerView.removeFromSuperview()
                            self.moveToNxt()
                        }
                    }
                }else{
                    let alert = UIAlertController(title: "Alert", message: "UserName And Password is not Correct", preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            alert.dismiss(animated: true)
                        }
                    }
                }
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Filed Are Blank Fill woth UserName and Password", preferredStyle: .alert)
            self.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    alert.dismiss(animated: true)
                }
            }
        }
    }
    
    
    func moveToNxt() {
        
    }
    
}
