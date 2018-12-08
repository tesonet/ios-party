//
//  UIView+Helper.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 06/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: View Border
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor {
        get {
            if let cgBorderColor = layer.borderColor {
                return UIColor.init(cgColor: cgBorderColor)
            } else {
                return .clear
            }
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    func setBorder(color: UIColor = .clear, width: CGFloat = 1) {
        viewBorderColor = color
        viewBorderWidth = width
    }
    
    // MARK: - Corner Radius
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            if newValue > 0 {
                self.setCornerRadius(0)
                self.layer.masksToBounds = true
            }
        }
    }
    
    /// Sets radius of specific view corners.
    func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner = [.topLeft, .topRight, .bottomRight, .bottomLeft]) {
        // Removing mask layer if radius is zero.
        if radius == 0 {
            layer.mask = nil
            
            // Applying mask layer.
        } else {
            let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners,
                                             cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }
}
