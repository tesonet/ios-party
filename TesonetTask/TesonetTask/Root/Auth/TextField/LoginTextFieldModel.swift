//
//  LoginTextFieldModel.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

enum LoginTextFieldType {
    case username
    case password
    
    var placeholder: String {
        switch self {
        case .username:
            return "Username"
        case .password:
            return "Password"
        }
    }
    
    var horizontalOffset: CGFloat {
        switch self {
        case .username:
            return -75
        case .password:
            return 0
        }
    }
    
    var isSecure: Bool {
        switch self {
        case .username:
            return false
        case .password:
            return true
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .username:
            return UIImage(named: "username")
        case .password:
            return UIImage(named: "pass")
        }
    }
    
}

class LoginTextFieldModel: ViewModel {
    
    let type: LoginTextFieldType
    var view: UIView?
    private let padding: CGFloat = 40
    private let height: CGFloat = 60
    
    init(type: LoginTextFieldType) {
        self.type = type
    }
    
    func buildView() -> UIView {
        return LoginTextField.instantiateFromXib()
    }
    
    func pinConstraints(view: UIView, superView: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoPinEdge(.leading, to: .leading, of: superView, withOffset: padding)
        view.autoPinEdge(.trailing, to: .trailing, of: superView, withOffset: -padding)
        view.autoAlignAxis(.horizontal, toSameAxisOf: superView, withOffset: type.horizontalOffset)
        view.autoSetDimension(.height, toSize: height)
    }
    
    func handleData(view: UIView) {
        guard let textFieldView = view as? LoginTextField else {
            return
        }
        
        textFieldView.textField.isSecureTextEntry = type.isSecure
        textFieldView.iconImgView.image = type.icon
        textFieldView.textField.attributedPlaceholder = NSAttributedString(string: type.placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func getTextFieldValue() -> String? {
        return (view as? LoginTextField)?.textField.text
    }

}
