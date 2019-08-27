//
//  TextFieldExtensions.swift
//  testio
//
//  Created by Justinas Baronas on 15/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//


import UIKit


extension UITextField {
    
    /// Adds left icon to textField
    public func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 12, height: 12))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
