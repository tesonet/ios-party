//
//  TestioUIConstants.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit

struct Colors {
    
    static let actionColor = UIColor.rgbColor(red: 159, green: 214, blue: 51, alpha: 1)
    static let backgroundColor = UIColor.rgbColor(red: 240, green: 240, blue: 240, alpha: 1)
    static let sortViewBackgroundColor = UIColor.rgbColor(red: 50, green: 69, blue: 118, alpha: 1)
    
}

extension UIColor {
    
    static func rgbColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let redComponent = CGFloat(red) / 255
        let greenComponent = CGFloat(green) / 255
        let blueComponent = CGFloat(blue) / 255
        
        return UIColor.init(red: redComponent,
                            green: greenComponent,
                            blue: blueComponent,
                            alpha: alpha)
    }
}
