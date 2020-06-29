//
//  KeychainManager.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit
import KeychainSwift

class KeychainManager
{
    static func getCredentialsForKey(_ key: CredentialsKey) -> String?
    {
        let keychain = KeychainSwift()
        var credential:String?
        switch key
        {
        case .username:
            credential = keychain.get(Constants.keychainUsernameKey)
        case .password:
            credential = keychain.get(Constants.keychainPasswordKey)
        case .token:
            credential = keychain.get(Constants.keychainTokenKey)
        }
        return credential
    }
    
    static func writeCredentialsForKey(_ key: CredentialsKey, value: String)
    {
        let keychain = KeychainSwift()
        switch key
        {
        case .username:
            keychain.set(value, forKey: Constants.keychainUsernameKey)
        case .password:
            keychain.set(value, forKey: Constants.keychainPasswordKey)
        case .token:
            keychain.set(value, forKey: Constants.keychainTokenKey)
        }
    }
    
    static func deleteCredentialsForKey(_ key: CredentialsKey)
    {
        let keychain = KeychainSwift()
        switch key
        {
        case .username:
            keychain.delete(Constants.keychainUsernameKey)
        case .password:
            keychain.delete(Constants.keychainPasswordKey)
        case .token:
            keychain.delete(Constants.keychainTokenKey)
        }
    }
}
