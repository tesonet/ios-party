//
//  KeyChain.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 17/04/2021.
//

import Foundation

struct Keychain {
    static func save(password: Data, account: String) {
        guard let service = Bundle.main.bundleIdentifier else {
            assert(false, "BundleIdentifier is missing")
        }

        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )

        if status == errSecDuplicateItem {
            update(password: password, account: account)
            return
        }

        guard status == errSecSuccess else {
            assert(false, "Save failed \(status)")
        }
    }
    
    private static func update(password: Data, account: String) {
        guard let service = Bundle.main.bundleIdentifier else {
            assert(false, "BundleIdentifier is missing")
        }
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )

        guard status != errSecItemNotFound else {
            assert(false, "Update failed, item is missing")
        }

        guard status == errSecSuccess else {
            assert(false, "Save failed \(status)")
        }
    }
}
