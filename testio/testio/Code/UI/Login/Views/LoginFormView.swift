//
//  LoginFormView.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import UIKit

protocol LoginFormViewDelegate: class {
    func loginFormViewDidSelectLogin(_ view: LoginFormView, username: String, password: String)
}

class LoginFormView: UIView, UITextFieldDelegate {
    weak var delegate: LoginFormViewDelegate?
    
    private let userNameTextField: TextFieldWithInsets
    private let passwordTextField: TextFieldWithInsets
    private let loginButton: UIButton
    
    override init(frame: CGRect) {
        let cornerRadius: CGFloat = 5
        let textInsets = UIEdgeInsets(top: 0.0, left: 56.0, bottom: 0.0, right: 8.0)
        
        self.userNameTextField = TextFieldWithInsets()
        self.userNameTextField.leftView = UIImageView(image: UIImage(named: "ico-username"))
        self.userNameTextField.leftViewMode = .always
        self.userNameTextField.backgroundColor = .white
        self.userNameTextField.layer.cornerRadius = cornerRadius
        self.userNameTextField.placeholder = NSLocalizedString("Username", comment: "")
        self.userNameTextField.textInsets = textInsets
        self.userNameTextField.autocorrectionType = .no
        self.userNameTextField.autocapitalizationType = .none
        self.userNameTextField.clearButtonMode = .whileEditing
        
        self.passwordTextField = TextFieldWithInsets()
        self.passwordTextField.leftView = UIImageView(image: UIImage(named: "ico-lock"))
        self.passwordTextField.leftViewMode = .always
        self.passwordTextField.backgroundColor = .white
        self.passwordTextField.layer.cornerRadius = cornerRadius
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        self.passwordTextField.textInsets = textInsets
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.autocapitalizationType = .none
        self.passwordTextField.clearButtonMode = .whileEditing
        
        self.loginButton = UIButton()
        self.loginButton.layer.cornerRadius = cornerRadius
        self.loginButton.setBackgroundImage(UIImage(named: "login-background"), for: .normal)
        self.loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        self.loginButton.isEnabled = false
        
        super.init(frame: frame)
        
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.loginButton.addTarget(self, action: #selector(self.didSelect(login:)), for: .touchUpInside)
        
        self.addSubview(self.userNameTextField)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.loginButton)
        
        self.makeConstraints()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.textFieldTextDidChangeNotification(_:)),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: self.userNameTextField)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.textFieldTextDidChangeNotification(_:)),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: self.passwordTextField)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.userNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.userNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let height: CGFloat = 60
        let spacing: CGFloat = 10
        
        self.userNameTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        self.userNameTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.passwordTextField.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor).with(constant: spacing).isActive = true
        self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor).with(constant: spacing).isActive = true
        self.loginButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // MARK: - UITextFieldTextDidChangeNotification
    
    @objc private func textFieldTextDidChangeNotification(_ notification: NSNotification) {
        let shouldEnableContinueButton = self.userNameTextField.text?.isEmpty == false && self.passwordTextField.text?.isEmpty == false
        self.loginButton.isEnabled = shouldEnableContinueButton
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userNameTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        
        if textField == self.passwordTextField && self.userNameTextField.text?.isEmpty == true {
            self.userNameTextField.becomeFirstResponder()
        }
        
        if textField == self.passwordTextField && self.userNameTextField.text?.isEmpty == false {
            self.didSelect(login: self.loginButton)
        }
        
        return true
    }
    
    // MARK: - Continue Button
    
    @objc private func didSelect(login button: UIButton) {
        self.delegate?.loginFormViewDidSelectLogin(self, username: self.userNameTextField.text!, password: self.passwordTextField.text!)
    }
    
    func clearFields() {
        self.userNameTextField.text = nil
        self.passwordTextField.text = nil
        
        self.userNameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}

private class TextFieldWithInsets: UITextField {
    var textInsets: UIEdgeInsets?
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let textInsets = self.textInsets else {
            return bounds
        }
        
        return UIEdgeInsetsInsetRect(bounds, textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let textInsets = self.textInsets else {
            return bounds
        }
        
        return UIEdgeInsetsInsetRect(bounds, textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let textInsets = self.textInsets else {
            return bounds
        }
        
        return UIEdgeInsetsInsetRect(bounds, textInsets)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return CGRect(x: 30.0, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    }
}
