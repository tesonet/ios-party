//
//  TesioHelper.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class TesioHelper: NSObject {
    
    // MARK: - Enums
    enum Constant {
        enum Color {
            static let mainLightGreen = UIColor(red: 64.0/255.0, green: 123.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
        static let tokenKey = "loginTokenKey"
    }
    
    
    // MARK: - Vars
    static var isUserLoggedIn: Bool {
        if let loggedIn = UserDefaults.standard.value(forKey: Constant.tokenKey) as? Bool {
            return loggedIn
        }
        return false
    }
    
    
    // MARK: - Methods
    public class func setLogin(token: String) {
        let tokenSaved: Bool = KeychainWrapper.standard.set(token, forKey: Constant.tokenKey, withAccessibility: .whenUnlockedThisDeviceOnly)
        debugPrint("Is token saved? : \(tokenSaved)")
    }
    
    public class func getLoginToken() -> String? {
        if let token: String = KeychainWrapper.standard.string(forKey: Constant.tokenKey, withAccessibility: .whenUnlockedThisDeviceOnly) {
            return token
        }
        return nil
    }
    
    
}





