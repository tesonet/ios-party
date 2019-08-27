//
//  Authentication.swift
//  testio
//
//  Created by Justinas Baronas on 18/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import Foundation
import KeychainSwift


final class Authentication {
    
    private static var keychain = KeychainSwift()
    
    // MARK: - Public Variables
    
    public static var isUserLoggedIn: Bool {
        return token != nil
    }
    
    /// Is used for authentication login request
    public static var token: String? {
        return keychain.get(K.Credentials.token)
    }
    
    public static var credentials: UserCredentials {
        return UserCredentials(
            username: keychain.get(K.Credentials.username) ?? "",
            password: keychain.get(K.Credentials.password) ?? "")
    }
    
    
    // MARK: - User authentication actions
    
    public static func saveUser(_ credentials: UserCredentials, withToken token: String) {
        keychain.set(credentials.username, forKey: K.Credentials.username)
        keychain.set(credentials.password, forKey: K.Credentials.password)
        keychain.set(token, forKey: K.Credentials.token)
    }
    
    public static func clearUserCredentials() {
        keychain.clear()
    }
}
