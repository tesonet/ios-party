//
//  SecureStorageService.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

final class SecureStorageService: SecureStorageServiceProtocol {
    
    enum Keys {
        static var authToken: String {
            "testio.authToken"
        }
    }
    
    let keychain = KeychainSwift()
    
    var authToken: String? {
        get {
            keychain.get(Keys.authToken)
        }
        set {
            if let value = newValue {
                keychain.set(value, forKey: Keys.authToken)
            } else {
                keychain.delete(Keys.authToken)
            }
        }
    }
}
