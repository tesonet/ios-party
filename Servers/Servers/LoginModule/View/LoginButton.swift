//
//  LoginButton.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

class LoginButton: BaseButton {
        
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            backgroundColor = newValue ? LoginConstants.button.colors.enabledBackground : LoginConstants.button.colors.disabledbackground
            
            setTitleColor(newValue ? LoginConstants.button.colors.textColorEnabled : LoginConstants.button.colors.textColorDisabled, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(LoginConstants.button.title, for: .normal)
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}

