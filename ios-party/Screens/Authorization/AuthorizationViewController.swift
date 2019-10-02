//
//  AuthorizationViewController.swift
//  ios-party
//
//  Created by Артём Зиньков on 10/1/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import UIKit

final class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.leftViewMode = .always
            usernameTextField.leftView = iconForTextField(image: UIImage(named: "ico-username"))
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.leftViewMode = .always
            passwordTextField.leftView = iconForTextField(image: UIImage(named: "ico-lock"))
        }
    }
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        #if DEBUG
        usernameTextField.text = "tesonet"
        passwordTextField.text = "partyanimal"
        logInButtonPressed()
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITextField.swizzleMethods()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UITextField.swizzleMethods()
    }
    
    @IBAction func logInButtonPressed() {
        let credentials = Credentials(username: usernameTextField.text ?? "",
                                      password: passwordTextField.text ?? "")
        APIManager.shared.authorize(withComponents: credentials.mapToJSON() as? [String: String], { [weak self] in
            Router.route(to: .ServerList)
            self?.dismiss(animated: true)
        }) { [weak self] _ in
            let alertController = UIAlertController(title: "An Error Occured", message: "Wrong Credentials", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alertController, animated: true)
        }
    }
    
    private func iconForTextField(image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    @objc private func onKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -max(0, logInButton.frame.maxY - keyboardFrame.minY)
        }
    }

    @objc private func onKeyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
}

fileprivate extension UITextField {
    
    /* Another options to move leftView is:
     - Subclass UITextField
     - Do moving in layoutSubviews (which is i consider as preffered)
     
     I just wanted to show that i know something about ObjC Runtime
     */
    static func swizzleMethods() {
        guard
            let originalMethod = class_getInstanceMethod(UITextField.self, #selector(leftViewRect(forBounds:))),
            let swizzledMethod = class_getInstanceMethod(UITextField.self, #selector(swizzled_leftViewRect(forBounds:)))
        else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc func swizzled_leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = swizzled_leftViewRect(forBounds: bounds)
        rect.origin.x = 15
        return rect
    }
}
