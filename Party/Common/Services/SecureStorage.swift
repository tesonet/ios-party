//
//  SecureStorage.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

let usernameKey = "usernameKey"
let passwordKey = "passwordKey"

class SecureStorage {
    
    // MARK: Dependencies
    
    let keychain: KeychainWrapper
    
    // MARK: - Init
    
    init(keychain: KeychainWrapper = KeychainWrapper.standard) {
        self.keychain = keychain
    }
    
    // MARK: - Public Methods
    
    func store(_ value: String?, forKey key: String) {
        guard let value = value else {
            keychain.removeObject(forKey: key)
            return
        }
        keychain.set(value, forKey: key)
    }
    
    func value(forKey key: String) -> String? {
        return keychain.string(forKey: key)
    }
    
    func clear() {
        keychain.removeAllKeys()
    }
}
