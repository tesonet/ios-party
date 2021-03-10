//
//  Localization.swift
//  Testio
//
//  Created by Andrii Popov on 3/8/21.
//

import Foundation

struct LoginLocalization {
    
    struct Alert {
        static var title: String {
            NSLocalizedString("alert.title", comment: "")
        }
        
        static var ok: String {
            NSLocalizedString("alert.ok", comment: "")
        }
    }
    
    struct Button {
        static var logIn: String {
            NSLocalizedString("login.button.title", comment: "")
        }
    }
    
    struct TextField {
        static var userNamePlaceholder: String {
            NSLocalizedString("login.userNameTextField.placeholder", comment: "")
        }
        
        static var passwordPlaceholder: String {
            NSLocalizedString("login.passwordTextField.placeholder", comment: "")
        }
    }
    
    struct Error {
        static var unauthorized: String {
            NSLocalizedString("unauthorized", comment: "")
        }
        
        static var unknown: String {
            NSLocalizedString("unknown", comment: "")
        }
    }
}
