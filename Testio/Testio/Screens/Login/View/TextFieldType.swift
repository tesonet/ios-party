//
//  TextFieldType.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import UIKit

enum TextFieldType {
    case username
    case password
}

extension TextFieldType {
    var placeholder: String {
        switch self {
        case .username:
            return LoginLocalization.TextField.userNamePlaceholder
        case .password:
            return LoginLocalization.TextField.passwordPlaceholder
        }
    }
    
    var leftViewMode: UITextField.ViewMode {
        switch self {
        case .username, .password:
            return .always
        }
    }
    
    var leftView: UIView? {
        switch self {
        case .username:
            return LoginConstants.textField.images.userIcon
        case .password:
            return LoginConstants.textField.images.lockIcon
        }
    }
    
    var font: UIFont {
        LoginConstants.textField.fonts.text
    }
    
    var textColor: UIColor {
        LoginConstants.colors.text
    }
    
    var isSecureTextEntry: Bool {
        self == .password ? true : false
    }
}
