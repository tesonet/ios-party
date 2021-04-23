//
//  KeychainService.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation
import Security

fileprivate enum KeychainKey: String {
    case token = "token"
}

final class KeychainService: KeychainServiceProtocol {
    
    var token: String? {
        get {
            if let data = getValue(for: KeychainKey.token.rawValue) {
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
        set {
             
            if let tokenString = newValue,
               let data = tokenString.data(using: .utf8) {
                save(value: data, forKey: KeychainKey.token.rawValue)
            } else {
                if let oldToken = token {
                    remove(value: oldToken, for: KeychainKey.token.rawValue)
                }
            }
        }
    }
    
    private func save(value: Data, forKey key: String) {
        
        let query = [kSecClass as String: kSecClassGenericPassword as String, kSecAttrAccount as String: key,
                    kSecValueData as String: value] as CFDictionary
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    private func getValue(for key: String) -> Data? {
        let query = [
                    kSecClass as String       : kSecClassGenericPassword,
                    kSecAttrAccount as String : key,
                    kSecReturnData as String  : kCFBooleanTrue!,
                    kSecMatchLimit as String  : kSecMatchLimitOne ] as CFDictionary
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            if let data = dataTypeRef as? Data {
                return data
            }
        }
        
        return nil
    }
    
    private func remove(value: String, for key: String) {
        let query = [kSecClass as String: kSecClassGenericPassword as String, kSecAttrAccount as String: key,
                    kSecValueData as String: value] as CFDictionary
        SecItemDelete(query)
    }
}
