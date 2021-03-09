//
//  TextField.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import UIKit

class TextField: UITextField {
    
    var onEnterText: (() -> ())?
    
    var hasValidText: Bool {
        !(text ?? "").isEmpty
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Constants.textField.colors.background
        layer.cornerRadius = Constants.geometry.cornerRadius
        layer.masksToBounds = true
        delegate = self
    }
    
    func update(with type: TextFieldType) {
        font = type.font
        textColor = type.textColor
        leftViewMode = type.leftViewMode
        leftView = type.leftView
        placeholder = type.placeholder
        isSecureTextEntry = type.isSecureTextEntry
    }
}

extension TextField {
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let defaultEditingRect = super.editingRect(forBounds: bounds)
        return defaultEditingRect.offsetBy(dx: Constants.textField.geometry.leftImageOffset, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let defaultTextRect = super.textRect(forBounds: bounds)
        return defaultTextRect.offsetBy(dx: Constants.textField.geometry.leftImageOffset, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let defaultViewRect = super.leftViewRect(forBounds: bounds)
        return defaultViewRect
            .offsetBy(dx: Constants.textField.geometry.leftImageOffset, dy: 0)
            .insetBy(dx: Constants.textField.geometry.leftViewXInset, dy: Constants.textField.geometry.leftViewYInset)
    }
}

extension TextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        onEnterText?()
    }
}
