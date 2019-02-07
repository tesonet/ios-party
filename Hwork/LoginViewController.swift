//
//  LoginViewController.swift
//  Hwork
//
//  Created by Robert P. on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userField: LoginTextField!
    @IBOutlet weak var passwField: LoginTextField!
    @IBOutlet weak var loginBtn: UIButton!
    var activeField:UITextField?
    var keyboardHt:CGFloat?
    
    var isLoggedIn:Bool {
        guard KeychainWrapper.standard.string(forKey: Const.Keychain.accessToken) != nil else {
            return false
        }
       return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addKeyboardNotif()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleLoggedIn()
    }

    private func setupViews() {
        userField.setupByType(type: .user)
        passwField.setupByType(type: .password)
        userField.roundEdges()
        passwField.roundEdges()
        loginBtn.roundEdges()
        userField.delegate = self
        passwField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        guard let name = userField.text ,let passw = passwField.text else {
            handleError(errorStatus: Const.Response.ErrorStatus.noCredentials)
            return
        }
        
        if name.count < 2 ||  passw.count < 2  {
            handleError(errorStatus: Const.Response.ErrorStatus.noCredentials)
            return
        }
        
        LoaderController.shared.show()
        Api.shared.requestToken(username: name, password: passw) { (token, errorStatus) in
            
            if let status = errorStatus {
                self.handleError(errorStatus: status)
                return
            }
            
            guard let authToken = token else {
                self.handleError(errorStatus: Const.Response.ErrorStatus.other)
                return
            }
            self.userField.text = ""
            self.passwField.text = ""
            KeychainWrapper.standard.set(authToken, forKey: Const.Keychain.accessToken)
            self.performSegue(withIdentifier: Const.Segues.serversSegue, sender: nil)
        }
    }
    
    private func handleError(errorStatus: Const.Response.ErrorStatus) {
        
        LoaderController.shared.hide()
        showAlert(text: errorStatus.rawValue, dismissHandler: nil)
    }
    
    private func handleLoggedIn() {
       
        view.isHidden = false
        if isLoggedIn {
            view.isHidden = true
            self.performSegue(withIdentifier: Const.Segues.serversSegue, sender: nil)
            
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addKeyboardNotif() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func adjustToKeyboard(keyboardHt:CGFloat?) {
        
        guard let kb_ht = keyboardHt else {
            return
        }
        let spacer:CGFloat = 50.0
        let ht = spacer + kb_ht
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: ht, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= ht
        let activeTextFieldRect: CGRect? = activeField?.frame
        if let activeTextFieldOrigin: CGPoint = activeTextFieldRect?.origin {
            if (!aRect.contains(activeTextFieldOrigin) ) {
                scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        keyboardHt = notification.keyboardSize?.height
        adjustToKeyboard(keyboardHt: keyboardHt)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        keyboardHt = nil
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}




extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeField = textField;
        adjustToKeyboard(keyboardHt: keyboardHt)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userField {
            passwField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
    }
    
}


extension UIView {
    func roundEdges() {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
}


extension Notification {
    var keyboardSize: CGSize? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
    }
}


extension UIViewController {
    
    typealias handler = () -> ()
    func showAlert(text: String, dismissHandler: handler? ) {
        
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if let completion = dismissHandler {
                completion()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
