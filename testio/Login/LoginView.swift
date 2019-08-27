//
//  LoginView.swift
//  testio
//
//  Created by Justinas Baronas on 14/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit

final class LoginView: NibView {
    
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    
    // MARK: - Variables
    
    public var onLoginTap: Closures?

    public var textFieldUsername: String {
        return usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    public var textFieldPassword: String {
        return passwordTextField.text ?? ""
    }
    
    private var isKeyboardPresent: Bool {
        return contentContainerView.frame.origin.y.isLess(than: 0)
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        usernameTextField.setLeftIcon(UIImage(named: "username-image")!)
        passwordTextField.setLeftIcon(UIImage(named: "password-image")!)
    }
    
    override func setupStyle() {
        loginButton.layer.cornerRadius = K.Style.buttonCornerRadius
    }
    
    
    // MARK: - Actions
    
    @IBAction func loginTapAction(_ sender: Any) {
        onLoginTap?()
    }
    
    
    // MARK: - Public methods
    
    public func moveContent(toHeight height: CGFloat) {
        if height.isEqual(to: 0) && isKeyboardPresent {
            UIView.animate(withDuration: 0.3) {
                self.contentContainerView.frame.origin.y = height
            }
        } else if !isKeyboardPresent {
            contentContainerView.frame.origin.y -= height
        }
    }
}
