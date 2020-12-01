//
//  AuthorizationRepository.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import Foundation
import SwiftKeychainWrapper

class AuthorizationRepository {
    
    // MARK: - Constants
    private struct Constants {
        static let tokenKey = "token"
    }
    
    // MARK: - Declarations
    static let shared: AuthorizationRepository = AuthorizationRepository()
    
    // MARK: - Dependencies
    private let keychainWrapper = KeychainWrapper.standard
    
    // MARK: - Methods
    public func set(token: String) {
        keychainWrapper.set(token, forKey: Constants.tokenKey, withAccessibility: .always)
    }
    
    public func remove() { // no need in this case, but in case we would logout
        keychainWrapper.removeObject(forKey: Constants.tokenKey)
    }
    
    public func token() -> String? {
        return keychainWrapper.string(forKey: Constants.tokenKey, withAccessibility: .always)
    }
}
