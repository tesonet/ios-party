//
//  LocalStorage.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

class LocalStorage {
    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "tkn")
        UserDefaults.standard.synchronize()
    }
    
    static func getToken() -> String? {
        guard let token = UserDefaults.standard.object(forKey: "tkn") as? String else {
            return nil
        }
        return token
    }
    
    static func deleteToken() {
        UserDefaults.standard.set(nil, forKey: "tkn")
        UserDefaults.standard.synchronize()
    }
    
    static func saveUser(name: String, password: String) {
        let credentials = Credentials(username: name, password: password)
        if !KeyChain.updateCredentials(credentials) {
            KeyChain.addCredentials(credentials)
        }
    }
    
    static func getUserCredentials() -> (String, String)? {
        guard let credentials = KeyChain.getCredentials() else { return nil }
        return (credentials.username, credentials.password)
    }
    
    static func deleteUserCredentials() {
        KeyChain.deleteCredentials()
    }
}
