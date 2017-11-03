//
//  UIColorExtension.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import Foundation
import UIKit

extension UIColor {
    convenience init (customRed red: CGFloat, green:CGFloat, blue:CGFloat, alpha: CGFloat){
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    static var appLoginButtonBg: UIColor {
        return UIColor(customRed: 159, green: 213, blue: 51, alpha: 1)
    }
    static var appTextFieldPlaceholder: UIColor {
        return UIColor(customRed: 179, green: 179, blue: 179, alpha: 1)
    }
    static var appListHeader: UIColor {
        return UIColor(customRed: 153, green: 153, blue: 153, alpha: 1)
    }
    static var appListContent: UIColor {
        return UIColor(customRed: 102, green: 102, blue: 102, alpha: 1)
    }
    static var appSeparator: UIColor {
        return UIColor(customRed: 153, green: 153, blue: 153, alpha: 1)
    }
    static var appToolbarBg: UIColor {
        return UIColor(customRed: 240, green: 240, blue: 240, alpha: 1)
    }
    static var appShadow: UIColor {
        return UIColor(customRed: 7, green: 38, blue: 56, alpha: 0.3)
    }
    
}
