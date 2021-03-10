//
//  ServersListConstants.swift
//  Testio
//
//  Created by Andrii Popov on 3/9/21.
//

import UIKit

struct ServersListConstants {
    struct activityIndicator {
        struct geometry {
            static let diameter = CGFloat(160)
            static let lineWidth = CGFloat(4)
        }
        
        struct colors {
            static let tintColor = UIColor.white
        }
    }
    
    struct infoBarView {
        struct geometry {
            static let shadowRadius = CGFloat(12)
            static let shadowOpacity = Float(0.17)
            static let shadowOffset = CGSize(width: 1, height: 8)            
        }
        
        struct colors {
            static let shadow = UIColor.black
        }
    }
    
    static let defaultAnimationDuration = 0.25
    
}
