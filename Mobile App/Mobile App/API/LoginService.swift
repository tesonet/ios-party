//
//  LoginService.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation

struct LoginService {
    
    private static let tokenKey = "LoginService.tokenKey"
    
    static var token: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func storeToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    static func clearTokne() {
        UserDefaults.standard.set(nil, forKey: tokenKey)
    }
}
