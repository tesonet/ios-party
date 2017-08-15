//
//  ViewController.swift
//  iOS Party
//
//  Created by Justas Liola on 14/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {
    
    @IBOutlet private     var logoImage:      UIImageView!
    @IBOutlet fileprivate var loginStackView: UIStackView!
    @IBOutlet fileprivate var userNameField:  UITextField!
    @IBOutlet fileprivate var passwordField:  UITextField!
    @IBOutlet private     var loginButton:    ThemeButton!
    
    @IBOutlet fileprivate var stackViewCenterConstrain: NSLayoutConstraint!
    
    private let loginVM = LoginVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        animateIn()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        loginVM.loading
            .bind(to: loginButton.rx.isLoading)
            .addDisposableTo(rx_disposeBag)
    }
    
    private func setupActions() {
        loginButton.rx.tap
            .subscribeNext(self, LoginViewController.login)
        
        dismissKeyboardOnTap()
        adjustToKeyboardWhenNeeded()
    }
    
    fileprivate func login() {
        
        guard let username = userNameField.text, let password = passwordField.text else { return } //This should never ever return.
        
        guard username != "", password != "" else {
            AppDelegate.showAlert(message: "Do you want me to fill in credentials?", title: "Missing credentials",
                                  cancelTitle: "No", extraAction: ("Yes, please", fillInCredentials))
            return
        }
        
        loginVM.login(username: username, password: password, completion: animateOut)
    }
    
    private func fillInCredentials() {
        //Debugging purposes...
        //In case I forget password
        userNameField.text = "tesonet"
        passwordField.text = "partyanimal"
    }

    private func animateOut() {
        UIView.animate(withDuration: 0.3, animations: { _ in
            self.logoImage     .alpha = 0
            self.loginStackView.alpha = 0
        }, completion: changeRootViewController)
    }
    
    private func animateIn() {
        logoImage     .alpha = 0
        loginStackView.alpha = 0
        
        UIView.animate(withDuration: 0.5) { _ in
            self.logoImage     .alpha = 1
            self.loginStackView.alpha = 1
        }
    }
    
    private func changeRootViewController(_ bool: Bool) {
        UIApplication.shared.keyWindow?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "\(ListViewController.self)")
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}


//MARK: - Keyboard
extension LoginViewController {
    
    func adjustToKeyboardWhenNeeded() {
        NotificationCenter.default
            .rx.notification(NSNotification.Name.UIKeyboardWillChangeFrame)
            .map{ $0 as NSNotification }
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardNotification(notification)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func keyboardNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                stackViewCenterConstrain.constant = -40
            } else {
                let overlap = (loginStackView.frame.origin.y + loginStackView.frame.height) - endFrame.origin.y
                if overlap > 0 {
                    stackViewCenterConstrain.constant -= overlap + 10 //Just because looks better
                }
            }
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordField.endEditing(true)
            login()
        default:
            break
        }
        
        return false
    }

}

