//
//  KeychainRepository.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import KeychainAccess

// MARK: - Constants
fileprivate let kAccessibilityLevel: Accessibility = .always
fileprivate let kAuthorizationTokenKey: String = "KeychainRepository_authorizationToken"

protocol KeychainRepositoryInterface {
    func authorizationToken() -> String?
    func setAuthorizationToken(_ token: String)
    func removeAuthorizationToken()
    func reset()
}

class KeychainRepository: KeychainRepositoryInterface {
    
    // MARK: - Methods
    func authorizationToken() -> String? {
        let keychain = Keychain().accessibility(kAccessibilityLevel)
        
        guard let authorizationToken: String = keychain[kAuthorizationTokenKey] else {
            return nil
        }
        
        return authorizationToken
    }
    
    func setAuthorizationToken(_ token: String) {
        let keychain = Keychain().accessibility(kAccessibilityLevel)
        keychain[kAuthorizationTokenKey] = token
    }
    
    func removeAuthorizationToken() {
        let keychain = Keychain().accessibility(kAccessibilityLevel)
        keychain[kAuthorizationTokenKey] = nil
    }
    
    func reset() {
        removeAuthorizationToken()
    }
}
