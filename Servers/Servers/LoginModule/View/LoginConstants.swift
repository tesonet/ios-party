//
//  LoginConstants.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

struct LoginConstants {
    struct textField {
        
        static let cornerRadius = CGFloat(5)
        static let backgroundColor = UIColor.white

        struct placeholders {
            static let usernamePlaceholder = "Username"
            static let passwordPlaceholder = "Password"
        }
        
        struct images {
            static let usernameImage = "usernameIcon"
            static let passwordImage = "passwordIcon"
        }
    }
    
    struct button {
        static let cornerRadius = CGFloat(5)
        static let title = "Log In"

        struct colors {
            static let enabledBackground = UIColor(red: 144.0/255.0, green: 207.0/255.0, blue: 61.0/255.0, alpha: 1)
            static let disabledbackground = UIColor.darkGray
            static let textColorEnabled = UIColor.white
            static let textColorDisabled = UIColor.lightText

        }
    }
    
    
}
