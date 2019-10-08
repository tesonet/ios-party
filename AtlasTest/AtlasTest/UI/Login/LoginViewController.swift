//
//  LoginViewController.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewController: AnyObject {
    static func makeLoginViewController(viewModel: LoginViewModel) -> UIViewController?
    func setInitUI()
    func setBeingAuthorizedUI()
}

class AppLoginViewController: UIViewController, LoginViewController {
    @IBOutlet private var userNameTextField: UITextField!
    @IBOutlet private var userNameBgView: UIView!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var passwordBgView: UIView!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var topLogoLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private var activityIndicator: GradientArcView!
    
    private var viewModel: LoginViewModel?
    private var loadingViewController:LoadingViewController?
    
    static func makeLoginViewController(viewModel: LoginViewModel) -> UIViewController? {
        guard let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LOGIN") as? AppLoginViewController else { return nil }
        newViewController.viewModel = viewModel
        return newViewController
    }
    
    func setInitUI() {
        activityIndicator.isHidden = true
        userNameTextField.setPadding(offset: 0.0)
        passwordTextField.setPadding(offset: 0.0)
        userNameTextField.text = ""
        passwordTextField.text = ""
        userNameTextField.textContentType = .init(rawValue: "")
        passwordTextField.textContentType = .init(rawValue: "")
        
        userNameBgView.layer.cornerRadius = 8.0
        passwordBgView.layer.cornerRadius = 8.0
        loginButton.layer.cornerRadius = 8.0
        
        userNameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        loginButton.isEnabled = true
    }
    
    func setBeingAuthorizedUI() {
        activityIndicator.rotate()
        activityIndicator.isHidden = false
        userNameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
    }
}

// MARK: - UIViewController lifecycle methods
extension AppLoginViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitUI()
        userNameBgView.isHidden = true
        passwordBgView.isHidden = true
        loginButton.isHidden = true
        topLogoLayoutConstraint.constant = 150.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topLogoLayoutConstraint.isActive = false
        topLogoLayoutConstraint.constant = 80.0
        topLogoLayoutConstraint.isActive = true
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.userNameBgView.isHidden = false
            self?.passwordBgView.isHidden = false
            self?.loginButton.isHidden = false
            }, completion: nil)
    }
}

// MARK: - Private methods
private extension AppLoginViewController {
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        viewModel?.usernameChanged(to: userNameTextField.text ?? "")
        viewModel?.passwordChanged(to: passwordTextField.text ?? "")
        viewModel?.loginButtonTapped()
    }
    
    @objc
    func tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        userNameTextField.endEditing(true)
        passwordBgView.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension AppLoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        if textField.tag == userNameTextField.tag { viewModel?.usernameChanged(to: userNameTextField.text ?? "")}
        if textField.tag == passwordTextField.tag { viewModel?.passwordChanged(to: passwordTextField.text ?? "")}
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch reason {
        case .committed:
            if textField.tag == userNameTextField.tag { viewModel?.usernameChanged(to: userNameTextField.text ?? "") }
            if textField.tag == passwordTextField.tag { viewModel?.passwordChanged(to: passwordTextField.text ?? "") }
            return
        case .cancelled: return
        @unknown default:
            return
        }
    }
}

// MARK: - UITextField extension
extension UITextField {
    func setPadding(offset: Float) {
        let textFieldHeight = frame.height
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(offset), height: textFieldHeight))
        leftView = paddingView
        leftViewMode = UITextField.ViewMode.always
    }
}

