//
//  TextFieldWithInsets.swift
//  testio
//
//  Created by Karolis Misiūra on 19/11/2017.
//  Copyright © 2017 Karolis Misiura. All rights reserved.
//

import UIKit

class TextFieldWithInsets: UITextField {
    
    var textPadding: UIEdgeInsets?
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let edgeInset = self.textPadding {
            return UIEdgeInsetsInsetRect(bounds, edgeInset)
        }
        return bounds
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if let edgeInset = self.textPadding {
            return UIEdgeInsetsInsetRect(bounds, edgeInset)
        }
        return bounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let edgeInset = self.textPadding {
            return UIEdgeInsetsInsetRect(bounds, edgeInset)
        }
        return bounds
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return CGRect(x: 8.0, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    }
}
