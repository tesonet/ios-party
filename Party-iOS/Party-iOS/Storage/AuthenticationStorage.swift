//
//  AuthenticationStorage.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

final class AuthenticationStorage: AuthenticationStorageDelegate {
    
    static var shared = AuthenticationStorage()
    
    private let tokenConstant = "access_token"
    
    func didUpdateAuthentication(_ authentication: Authorizable) {
        if let data = authentication.accessToken.data(using: .utf8) {
            _ = KeyChain.save(key: tokenConstant, data: data)
        }
    }
    
    func authentication() -> Authorizable {
        if let data = KeyChain.load(key: tokenConstant), let tokenValue = String(data: data, encoding: .utf8) {
            return Authentication(accessToken: tokenValue, tokenType: "Bearer")
        }
        return Authentication(accessToken: "", tokenType: "Bearer")
    }
    
    var isLoggedIn: Bool {
        if let data = KeyChain.load(key: tokenConstant), String(data: data, encoding: .utf8) != nil {
           return true
        }
        return false
    }
    
    func clearData() {
        _ = KeyChain.delete(key: tokenConstant)
    }
}

struct Authentication: Authorizable {
    var accessToken: String
    var tokenType: String
}
