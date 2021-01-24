//
//  RoundedButton.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    // MARK: - Declarations
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
