//
//  KeychainService.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/30/19.
//  Copyright © 2019 krokus. All rights reserved.
//
import Security
import UIKit

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

struct Credentials {
    var username: String
    var password: String
}

class KeyChain {
    static let server = "playground.tesonet.lt"

    static func addCredentials(_ credentials: Credentials) -> Bool {
        let account = credentials.username
        guard let password = credentials.password.data(using: String.Encoding.utf8) else { return false }
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: KeyChain.server,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return false}
        return true
    }
    
    static func getCredentials() -> Credentials? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: KeyChain.server,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            return nil
        }
        return Credentials(username: account, password: password)
    }
    
    static func updateCredentials(_ credentials: Credentials) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: KeyChain.server]
        let account = credentials.username
        guard let password = credentials.password.data(using: String.Encoding.utf8) else { return false }
        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: password]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {  return false }
        guard status == errSecSuccess else {  return false }
        return true
    }
    
    static func deleteCredentials() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: KeyChain.server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { return false }
        return true
    }

}
