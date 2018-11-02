//
//  RoundedButton.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable private var cornerRadius: CGFloat = 5.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    fileprivate func setupView() {
        layer.cornerRadius = cornerRadius
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14.0)
    }

}
