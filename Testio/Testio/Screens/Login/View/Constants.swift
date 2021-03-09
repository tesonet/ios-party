//
//  Constants.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import UIKit

struct Constants {
    struct textField {
        struct geometry {
            static let leftImageOffset = CGFloat(10)
            static let leftViewXInset = CGFloat(4)
            static let leftViewYInset = CGFloat(5)
        }
        
        struct fonts {
            static let text = UIFont(name: "HelveticaNeue", size: 12)!
        }
        
        struct images {
            static let userIcon = UIImageView(image: UIImage(named: "user"))
            static let lockIcon = UIImageView(image: UIImage(named: "lock"))
        }
        
        struct colors {
            static let background = UIColor.white
        }
    }
    
    struct loginButton {
        struct color {
            static let enabledBackground = UIColor(named: "loginButtonEnabled")!
            static let disabledBackground = UIColor(named: "loginButtonDisabled")!
        }
    }
    
    struct geometry {
        static let cornerRadius = CGFloat(4)
    }
    
    struct colors {
        static let text = UIColor.darkGray
    }
    
}
