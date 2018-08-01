//
//  TestioKeychainWrapper.swift
//  Testio
//
//  Created by Mindaugas on 28/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation

enum TestioKeychainError: Error {
    case noUsernameSet
    case passwordReadFailed
    case passwordSaveFailed
    case credentialDeleteFailed
}

protocol CredentialsStoring {

    func save(testioUser: TestioUser) throws
}

class TestioKeychainWrapper: CredentialsStoring {
    
    private let usernameDefaultsKey = "username-key"
    
    func save(testioUser: TestioUser) throws {
        let passwordItem = KeychainPasswordItem(service: TestioKeychainConfiguration.serviceName,
                                                account: testioUser.username,
                                                accessGroup: TestioKeychainConfiguration.accessGroup)
        
        do {
            try passwordItem.savePassword(testioUser.password)
            UserDefaults.standard.set(testioUser.username, forKey: usernameDefaultsKey)
        } catch {
            throw TestioKeychainError.passwordSaveFailed
        }
    }
    
    func deleteCredentials() throws {
        guard let username = UserDefaults.standard.value(forKey: usernameDefaultsKey) as? String else {
            throw TestioKeychainError.noUsernameSet
        }
        
        let passwordItem = KeychainPasswordItem(service: TestioKeychainConfiguration.serviceName,
                                                account: username,
                                                accessGroup: TestioKeychainConfiguration.accessGroup)
        
        do {
            try passwordItem.deleteItem()
            UserDefaults.standard.set(nil, forKey: usernameDefaultsKey)
        } catch {
            throw TestioKeychainError.credentialDeleteFailed
        }
    }
    
    func retrieveUser() throws -> TestioUser {
        guard let username = UserDefaults.standard.value(forKey: usernameDefaultsKey) as? String else {
            throw TestioKeychainError.noUsernameSet
        }
        
        let passwordItem = KeychainPasswordItem(service: TestioKeychainConfiguration.serviceName,
                                                account: username,
                                                accessGroup: TestioKeychainConfiguration.accessGroup)
        guard let keychainPassword = try? passwordItem.readPassword() else {
            throw TestioKeychainError.passwordReadFailed
        }
        
        return TestioUser(username: username, password: keychainPassword)
    }
    
}
