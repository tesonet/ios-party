import Foundation
import Security

let serviceIdentifier = "KeychainService"
let accountIdentifier = "AuthenticatedUser"

struct KeychainService {
    public static func save(token: String) {
        if let data = token.data(using: .utf8) {
            let query = [kSecClass: kSecClassGenericPassword,
                         kSecAttrService: serviceIdentifier,
                         kSecAttrAccount: accountIdentifier,
                         kSecValueData: data] as [CFString : Any]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    public static func deleteToken() {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrService: serviceIdentifier,
                     kSecAttrAccount: accountIdentifier,
                     kSecReturnData: kCFBooleanTrue,
                     kSecMatchLimit: kSecMatchLimitOne] as [CFString : Any]
        SecItemDelete(query as CFDictionary)
    }
    
    public static func token() -> String? {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrService: serviceIdentifier,
                     kSecAttrAccount: accountIdentifier,
                     kSecReturnData: kCFBooleanTrue,
                     kSecMatchLimit: kSecMatchLimitOne] as [CFString : Any]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if let retrievedData = dataTypeRef as? NSData, status == errSecSuccess {
            return String(data: retrievedData as Data, encoding: .utf8)
        }
        return nil
    }
}

