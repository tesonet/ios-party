//
//  KeychainManager.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation
import KeychainAccess

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    private let tokenKey = "tokenKey"
    
    private let keychain = Keychain(service: "com.paulius.party")
    
    func getToken() -> String? {
        guard let authData = keychain[data: tokenKey] else {
            return nil
        }
        return try? JSONDecoder().decode(String.self, from: authData)
    }
    
    func set(token: String?) {
        if let encoded = try? JSONEncoder().encode(token) {
            keychain[data: tokenKey] = encoded
        }
    }
}
