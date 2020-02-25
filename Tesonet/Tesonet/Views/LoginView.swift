//
//  LoginView.swift
//  Tesonet
//

import UIKit

private let errorHeight: CGFloat = 21

class LoginView: UIView {

    @IBOutlet private weak var userNameImageView: UIImageView!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordImageView: UIImageView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorLabelHeightCostraint: NSLayoutConstraint!
    private var loginClickHandler: (() -> Void)?

    func prepareView(with handler: @escaping () -> Void) {
        let placeholderColor = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        userNameImageView.image = #imageLiteral(resourceName: "user_icon")
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "UserNamePlaceholer".localized, attributes: placeholderColor)
        passwordImageView.image = #imageLiteral(resourceName: "lock_icon")
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PasswordPlaceholder".localized, attributes: placeholderColor)
        loginClickHandler = handler
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        hideError()
    }

    func showError(_ text: String) {
        errorLabel.text = text
        errorLabelHeightCostraint.constant = errorHeight
    }

    func hideError() {
        errorLabelHeightCostraint.constant = 0.0
    }

    @IBAction func didClickLogin(_ sender: UIButton) {
        loginClickHandler?()
    }

    func getLoginInfo() -> LoginModel? {
        return LoginModel(userName: userNameTextField.text, password: passwordTextField.text)
    }
    
    func clearLoginInfo() {
        userNameTextField.text = nil
        passwordTextField.text = nil
    }
}

extension LoginView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideError()
        return true
    }
}
