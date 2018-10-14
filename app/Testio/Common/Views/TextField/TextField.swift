//
//  TextField.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: ViewFromXib {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBInspectable weak var icon: UIImage? {
        get {
            return iconImageView.image
        } set {
            iconImageView.image = newValue
        }
    }
    
    @IBInspectable var placeholder: String? {
        get {
            return textField.placeholder
        } set {
            textField.placeholder = newValue
        }
    }
    
    @IBInspectable var isSecureText: Bool {
        get {
            return textField.isSecureTextEntry
        } set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    @IBInspectable var isLast: Bool {
        get {
            return textField.returnKeyType == .done
        } set {
            textField.returnKeyType = newValue ? .done : .next
        }
    }
    
    @IBInspectable var textFieldTag: Int = 0 {
        didSet {
            tag = textFieldTag
            textField.tag = textFieldTag
        }
    }
    
    weak var delegate: UITextFieldDelegate? {
        get {
            return textField.delegate
        } set {
            textField.delegate = newValue
        }
    }
    
    var text: String? {
        get {
            return textField.text
        }
    }
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = 5
    }
    
    func focus() {
        textField.becomeFirstResponder()
    }
}
