//
//  ServerConstants.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import UIKit

struct ServerConstants {
    struct cell {
        static let textColor = UIColor.darkGray
    }
    
    struct titleView {
        struct labels {
            static let leftLabelText = "Server"
            static let rightLabelText = "Distance"
            static let textColor = UIColor.lightGray
        }
        
        static let shadowColor = UIColor.lightGray
        static let shadowOffset = CGSize(width: 1, height: 15)
        static let shadowRadius: CGFloat = 10
        static let shadowOpacity: Float = 0.15
    }
    
    struct button {
        static let image = UIImage(named: "iconSort")!
        static let backgroundColor = UIColor(red: 58.0 / 255.0, green: 61.0 / 255.0, blue: 89.0 / 255.0, alpha: 1)
        static let title = "Sort"
        static let tintColor = UIColor.white

    }
}
