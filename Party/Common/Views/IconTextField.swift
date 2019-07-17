//
//  IconTextField.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

@IBDesignable
class IconTextField: UITextField {
    
    // MARK: - States

    /// A leftview icon image.
    @IBInspectable
    var icon: UIImage? {
        didSet {
            updateUI()
        }
    }
    
    // A radius of the rounded corners
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        guard let icon = icon else {
            leftViewMode = .never
            return
        }
        
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: 35,
                                                     height: frame.size.height)))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: view.center.x,
                                                                  y: view.center.y-5),
                                                  size: CGSize(width: 10,
                                                               height: 10)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = icon
        view.addSubview(imageView)
        
        leftView = view
        leftViewMode = .always
    }
}
