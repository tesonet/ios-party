//
//  KeyChain.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation
import Security

final class KeyChain {
    
    class func load(key: String) -> Data? {
        let query = [
            String(kSecClass): kSecClassGenericPassword,
            String(kSecAttrAccount): key,
            String(kSecReturnData): kCFBooleanTrue!,
            String(kSecMatchLimit): kSecMatchLimitOne] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == noErr else { return nil }
        return dataTypeRef as! Data?
    }
    
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            String(kSecClass): String(kSecClassGenericPassword),
            String(kSecAttrAccount): key,
            String(kSecValueData): data ] as [String : Any]
        _ = delete(key: key)
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func delete(key: String) -> OSStatus {
        let query = [
            String(kSecClass): String(kSecClassGenericPassword),
            String(kSecAttrAccount): key] as [String : Any]
        return SecItemDelete(query as CFDictionary)
    }

}
