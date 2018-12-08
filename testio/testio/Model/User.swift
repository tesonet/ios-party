//
//  User.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import KeychainSwift

class User: Codable {
    
    // potentially here goes user properties
}

// MARK: - Authorization

extension User {
    private enum Constants {
        static let authUserNameKey = "userAuthUserNameKey"
        static let authPasswordKey = "userAuthPasswordKey"
        static let authTokenKey = "userAuthTokenKey"
        static let didSignInKey = "userDidSignInKey"
    }
    
    struct Auth {
        let username: String
        let password: String
        let token: String?
    }
    
    private static let keychain = KeychainSwift()
    
    private static var authCache: Auth?
    
    static var auth: Auth? {
        return authCache ?? {
            guard let username = keychain.get(Constants.authUserNameKey),
                  let password = keychain.get(Constants.authPasswordKey)
                else {
                    return nil
            }
            authCache = Auth(username: username, password: password, token: keychain.get(Constants.authTokenKey))
            return authCache
        }()
    }
    
    static func authorized(_ auth: Auth?) throws {
        guard let auth = auth,
              let token = auth.token
            else {
                User.didSignIn = false
                keychain.clear()
                return
        }
        
        authCache = auth
        User.didSignIn = true
        
        guard keychain.set(token, forKey: Constants.authTokenKey, withAccess: .accessibleAfterFirstUnlock)
            else {
                throw "Error saving auth token to keychain"
        }
        
        guard keychain.set(auth.username, forKey: Constants.authUserNameKey, withAccess: .accessibleAfterFirstUnlock)
            else {
                throw "Error saving userName to keychain"
        }
        
        guard keychain.set(auth.password, forKey: Constants.authPasswordKey, withAccess: .accessibleAfterFirstUnlock)
            else {
                throw "Error saving password to keychain"
        }
    }
    
    static var didSignIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.didSignInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.didSignInKey)
        }
    }
}
