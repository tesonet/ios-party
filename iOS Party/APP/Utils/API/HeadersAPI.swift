//
//  HeadersAPI.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyUserDefaults

extension API.Headers {
    
    //Commented lines show my initial token storing.
    
//    private static var token: String? {
//        get { return Defaults[.token] }
//        set { Defaults[.token] = newValue }
//    }
    
    static func isLoggedIn() -> Bool {
        let token = getToken()
        return token != nil && token != ""
        
//        return token != nil
    }
    
    static func clear() {
        authorize(token: "")
        
        //        token = nil
    }
    
    private static func getToken() -> String? {
        do {
            let passwordItem = KeychainPasswordItem(service: "iOSParty", account: "password", accessGroup: nil)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            return nil
        }
    }
    
    static func authorize(token: String) {
        do {
            let passwordItem = KeychainPasswordItem(service: "iOSParty", account: "password", accessGroup: nil)
            try passwordItem.savePassword(token)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
//        self.token = token
    }
    
    static var all: [String: String] {
        var all = [String: String]()
        
        if let token = getToken() { all["Authorization"] = "Bearer \(token)" }
        
//        if let token = token { all["Authorization"] = "Bearer \(token)" }
        
        return all
    }
}

private extension DefaultsKeys {
    static let token = DefaultsKey<String?> ("token")
}
