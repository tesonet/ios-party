//
//  KeychainHelper.swift
//  Servers
//
//  Created by Rimantas Lukosevicius on 11/06/2018.
//  Copyright © 2018 Rimantas Lukosevicius. All rights reserved.
//

import UIKit

class KeychainHelper: NSObject {
    let server = "playground.tesonet.lt"
    
    func saveCredentials(username : String, password : String) -> Bool {
        let query: [String : Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: username,
            kSecAttrServer as String: server,
            kSecValueData as String : password.data(using: .utf8) as Any ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getCredentials() -> (Bool, String?, String?) {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            return (false, nil, nil)
        }
        
        guard status == errSecSuccess else {
            return (false, nil, nil)
        }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String else {
            return (false, nil, nil)
        }
        
        return (true, account, password)
    }
    
    func deleteCredentials() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]
        
        let status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }
}
