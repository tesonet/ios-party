//
//  LoginService.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import UIKit

struct LoginService {
    
    private static let tokenKey = "LoginService.tokenKey"
    
    static var token: String? {
        //TODO - Keychain
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func storeToken(_ token: String) {
        //TODO - Keychain
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    static func clearToken() {
        //TODO - Keychain
        UserDefaults.standard.set(nil, forKey: tokenKey)
    }
    
    static func logOutUser() {
        LoginService.clearToken()
        
        let questionnaireVC = LoginViewController.createFrom(storyboard: .login)
        
        UIApplication.setRootVC {
            UIApplication.topViewController()?.present(questionnaireVC, animated: false, completion: nil)
        }
        
    }
}
