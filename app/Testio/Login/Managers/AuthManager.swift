//
//  AuthManager.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import Foundation
import SAMKeychain
import PromiseKit

class AuthManager {
    static let shared = AuthManager()
    fileprivate static let testioKeychainServiceKey = "TestioService"
    fileprivate static let testioAccountKey = "jp.Testio.keychain"
    fileprivate let serviceManager = AuthServiceManager()
    
    var isAuthorized: Bool {
        get {
            if let _ = token {
                return true
            } else {
                return false
            }
        }
    }
    
    var token: String? {
        get {
            return SAMKeychain.password(forService: AuthManager.testioKeychainServiceKey, account: AuthManager.testioAccountKey)
        }
    }
    
    func login(withUsername username: String, password: String) -> Promise<Bool> {
        return serviceManager.login(withUsername: username, password: password).then { [weak self] responseData -> Promise<Bool> in
            if let authResponse = responseData.decode(AuthResponseModel.self) {
                self?.saveToken(authResponse.token)
            }
            
            return .value(true)
        }
    }
    
    func logout() {
        deleteToken()
    }
    
    fileprivate func saveToken(_ token: String) {
        SAMKeychain.setPassword(token, forService: AuthManager.testioKeychainServiceKey, account: AuthManager.testioAccountKey)
    }
    
    fileprivate func deleteToken() {
        SAMKeychain.deletePassword(forService: AuthManager.testioKeychainServiceKey, account: AuthManager.testioAccountKey)
    }
}
