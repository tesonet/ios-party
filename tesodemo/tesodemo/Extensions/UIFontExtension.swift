//
//  UIFontExtension.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import UIKit
import Foundation



extension UIFont {
    
    enum AppFont: String {
        case regular = "Roboto-Regular"
        case light = "Roboto-Light"
        case bold = "Roboto-Bold"
        case medium = "Roboto-Medium"
        
        var name: String {
            return self.rawValue
        }
    }
    
    class func applicationFont(_ fontName: AppFont, size: CGFloat) -> UIFont {
        return UIFont(name: fontName.name, size: size)!
    }
    

}
