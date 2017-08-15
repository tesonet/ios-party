//
//  UIColor+Theme.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import UIKit

//appColor
extension UIColor {
    
    private convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class var appGreen: UIColor { return UIColor(hex: 0xA0D342) }
    class var appGray: UIColor  { return UIColor(hex: 0xE3E6E8) }
    
}

//highlightedColor
extension UIColor {
    private var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
    
    var highlightedColor: UIColor {
        let color = self.components
        return UIColor(red:   color.red   * 0.534,
                       green: color.green * 0.534,
                       blue:  color.blue  * 0.534,
                       alpha: color.alpha)
    }
}
