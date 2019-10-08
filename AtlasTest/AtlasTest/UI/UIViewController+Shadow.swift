//
//  UIViewController+Shadow.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 10/2/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func addShadow(color: UIColor = UIColor.black, opacity: Float = 0.5, radius: CGFloat = 10, scale: Bool = true) {
        layer.masksToBounds = true
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
