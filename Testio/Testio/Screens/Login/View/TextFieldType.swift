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
            return Localization.TextField.userNamePlaceholder
        case .password:
            return Localization.TextField.passwordPlaceholder
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
            return Constants.textField.images.userIcon
        case .password:
            return Constants.textField.images.lockIcon
        }
    }
    
    var font: UIFont {
        Constants.textField.fonts.text
    }
    
    var textColor: UIColor {
        Constants.colors.text
    }
    
    var isSecureTextEntry: Bool {
        self == .password ? true : false
    }
}
