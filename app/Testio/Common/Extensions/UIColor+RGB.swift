//
//  UIColor+RGB.swift
//  Testio
//
//  Created by Julius on 13/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 255.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255.0)
    }
}
