//
//  Authorization.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

protocol AuthorizationInterface {
    static var shared: AuthorizationInterface { get }
    
    func setToken(token: String)
    func token() -> String?
    func isLoggedIn() -> Bool
    func logout()
}

class Authorization: AuthorizationInterface {
    
    // MARK: - Declarations
    static var shared: AuthorizationInterface = Authorization()
    
    // MARK: - Dependencies
    let keychainRepository: KeychainRepositoryInterface = KeychainRepository()

    // MARK: - Methods
    func setToken(token: String) {
        keychainRepository.setAuthorizationToken(token)
        NotificationCenter.default.post(Notification.DidLogin(authorizationToken: token))
    }
    
    func token() -> String? {
        return keychainRepository.authorizationToken()
    }
    
    func isLoggedIn() -> Bool {
        return token() != nil
    }
    
    func logout() {
        keychainRepository.removeAuthorizationToken()
        NotificationCenter.default.post(Notification.DidLogout())
    }
}
