//
//  LoginViewController.swift
//  Testio
//
//  Created by Julius on 13/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit
import GSMessages

class LoginViewController: ViewController {
    @IBOutlet weak var loginContainerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    fileprivate var originalloginContainerVerticalConstraintConstant: CGFloat = 0
    
    var errorMessage: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        originalloginContainerVerticalConstraintConstant = loginContainerVerticalConstraint.constant
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let message = errorMessage {
            showMessage(message, type: .error)
            errorMessage = nil
        }
    }
    
    @IBAction func onLogInButtonTap(_ sender: Any) {
        guard let username = usernameTextField.text, username.count > 0 else {
            showMessage("Please enter username", type: .error)
            return
        }
        
        guard let password = passwordTextField.text, password.count > 0 else {
            showMessage("Please enter password", type: .error)
            return
        }
        
        login(withUsername: username, password: password)
    }
    
    func login(withUsername username: String, password: String) {
        AuthManager.shared.login(withUsername: username, password: password).done { [weak self] success in
            if success {
                Router.navigate(.loading)
            } else {
                self?.showMessage("Invalid credentials", type: .error)
            }
        }.catch { [weak self] error in
            self?.showMessage(error.localizedDescription, type: .error)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let loginContainerBottom = loginContainerView.frame.origin.y + loginContainerView.frame.size.height
        let screenHeight = view.frame.size.height
        let freeSpace = screenHeight - loginContainerBottom
        
        if (freeSpace < keyboardSize.size.height) {
            adjustLoginContainer(withOffset: keyboardSize.height - freeSpace,
                                 duration: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                                 curve: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        adjustLoginContainer(withOffset: 0,
                             duration: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
                             curve: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt)
    }
    
    func adjustLoginContainer(withOffset offset: CGFloat, duration: TimeInterval?, curve: UInt?) {
        loginContainerVerticalConstraint.constant = originalloginContainerVerticalConstraintConstant - offset
        
        if let duration = duration, let curve = curve {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == usernameTextField.tag {
            passwordTextField.focus()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
