//
//  KeychainManager.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import Foundation
import Security

class KeychainManager: NSObject {
    
    class func set(value: String, key: String) -> Bool {
        guard let value = value.data(using: String.Encoding.utf8) else {
            return false
        }
        
        _ = KeychainManager.delete(key: key) // Delete value before storing new
        
        let query: [String : Any] = [
            String(kSecClass)           : kSecClassGenericPassword,
            String(kSecAttrAccount)     : key,
            String(kSecValueData)       : value
        ]
        
        let resultCode = SecItemAdd(query as CFDictionary, nil)
        
        return resultCode == noErr
    }

    class func get(_ key: String) -> String? {
        
        let query: [String: Any] = [
            String(kSecClass)           : kSecClassGenericPassword,
            String(kSecAttrAccount)     : key,
            String(kSecReturnData)      : kCFBooleanTrue,
            String(kSecMatchLimit)      : kSecMatchLimitOne
        ]
        
        
        var result: AnyObject?
        
        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if resultCode == noErr, let result = result as? Data, let str = String(data: result, encoding: .utf8){
            return str
        }
        
        return nil
    }

    class func delete(key: String) -> Bool {
        let query: [String: Any] = [
            String(kSecClass)           : kSecClassGenericPassword,
            String(kSecAttrAccount)     : key
        ]
        let resultCode = SecItemDelete(query as CFDictionary)
        
        return resultCode == noErr
    }

}
