//
//  TextField.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

enum LoginTextFieldType {
    case username
    case password
}

extension LoginTextFieldType {
    var placeholder: String {
        switch self {
        case .username:
            return LoginConstants.textField.placeholders.usernamePlaceholder
        case .password: return LoginConstants.textField.placeholders.passwordPlaceholder
        }
    }
    
    var leftView: UIView {
        let imageName = self == .username ? LoginConstants.textField.images.usernameImage : LoginConstants.textField.images.passwordImage
        return UIImageView(image: UIImage(named: imageName))
    }
}

protocol TextFieldProtocol: class {
    var textDidChange: (() -> ())? { get set }
    
    func isValid() -> Bool
    func set(type: LoginTextFieldType)
}

class LoginTextField: UITextField, TextFieldProtocol {
    var textDidChange: (() -> ())?
    
    func isValid() -> Bool {
        return !(text ?? "").isEmpty
    }
    
    func set(type: LoginTextFieldType) {
        placeholder = type.placeholder
        textColor = .darkGray
        leftView = type.leftView
        leftViewMode = .always
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        
        layer.cornerRadius = LoginConstants.textField.cornerRadius
        delegate = self
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds).offsetBy(dx: 10, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).offsetBy(dx: 10, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        super.leftViewRect(forBounds: bounds).offsetBy(dx: 12, dy: 0).insetBy(dx: 3, dy: 3)
    }
}

extension LoginTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textDidChange?()
    }
}
