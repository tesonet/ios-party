//
//  LoginScreenTextView.swift
//  GreatiOSApp
//
//  Created by Domas on 4/6/17.
//  Copyright © 2017 Sonic Team. All rights reserved.
//

import UIKit

@IBDesignable
class LoginScreenTextField: UITextField {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        self.layer.cornerRadius = 3

        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (leftImage?.size.width)! + 25.0, height: (leftImage?.size.height)!/1.5))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: color])
    }
}
