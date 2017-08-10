import Foundation
import KeychainAccess

private let keychainUsernameKey = "username"
private let keychainPasswordKey = "password"

struct Authentication {
    static private let keychain = Keychain()
    
    static var serviceToken: String?
    
    static var isUserLoggedIn: Bool {
        return userCredentials != nil
    }
    
    static var userCredentials: Credentials? {
        get {
            return savedUserCredentials()
        } set {
            saveUserCredentials(newValue)
        }
    }
    
    static func destroy() {
        saveUserCredentials(nil)
        serviceToken = nil
    }
    
    // MARK: Private
    
    private static func saveUserCredentials(_ credentials: Credentials?) {
        keychain[keychainUsernameKey] = credentials?.username
        keychain[keychainPasswordKey] = credentials?.password
    }
    
    private static func savedUserCredentials() -> Credentials? {
        let username = keychain[keychainUsernameKey]
        let password = keychain[keychainPasswordKey]
        
        if let username = username, let password = password {
            return Credentials(username: username, password: password)
        } else {
            return nil
        }
    }
}
