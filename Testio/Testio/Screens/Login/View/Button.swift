//
//  Button.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import UIKit

class Button: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = LoginConstants.geometry.cornerRadius
        layer.masksToBounds = true
        
        backgroundColor = LoginConstants.loginButton.color.enabledBackground
        setTitle(LoginLocalization.Button.logIn, for: .normal)
    }
    
    func enable() {
        isEnabled = true
        setBackgroundColor(color: LoginConstants.loginButton.color.enabledBackground, forState: .normal)
    }
    
    func disable() {
        isEnabled = false
        setBackgroundColor(color: LoginConstants.loginButton.color.disabledBackground, forState: .disabled)
    }
    
    private func setBackgroundColor(color: UIColor, forState: UIControl.State) {
      UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
      if let context = UIGraphicsGetCurrentContext() {
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: forState)
      }
    }
}
