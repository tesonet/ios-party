//
//  LoginViewTextField.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit

class LoginViewTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let newFrame = bounds.insetBy(dx: 40.0, dy:20.0)
        return newFrame
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let newFrame = bounds.insetBy(dx: 40.0, dy:20.0)
        return newFrame
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var newFrame = super.leftViewRect(forBounds: bounds)
        newFrame.origin.x += 13
        return newFrame
    }
}
