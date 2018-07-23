import Foundation
import KeychainSwift

final class UserSession {
	
    private let accessTokenKey = "UserSession_accessToken"
    private struct LoginKeys {
        static let username = "UserSession_username"
        static let password = "UserSession_password"
    }
    
    // Singelton
    static let shared = UserSession()
    fileprivate init() {}

    /// URLRequest Bearer authorization token.
    var token: String? {
		set {
            KeychainSwift().set(newValue ?? "", forKey: accessTokenKey)
		}
        get {
            guard let accessToken = KeychainSwift().get(accessTokenKey), !accessToken.isEmpty else {
                return nil
            }
            return accessToken
        }
	}
    
    /// User sign in crudentials (username, password) tuple.
    var signInDetails: (username: String, password: String)? {
        set {
            KeychainSwift().set(newValue?.username ?? "", forKey: LoginKeys.username)
            KeychainSwift().set(newValue?.password ?? "", forKey: LoginKeys.password)
        }
        get {
            guard let username = KeychainSwift().get(LoginKeys.username), !username.isEmpty,
                let password = KeychainSwift().get(LoginKeys.password), !password.isEmpty else {
                    return nil
            }
            
            return (username, password)
        }
    }
	
    /**
     Sign out.
     
     - parameter forgetLogin: true if login crudentials to be deleted from memory.
     */
    func signOut(forgetLogin: Bool) {
        token = nil
        if forgetLogin {
            signInDetails = nil
        }
	}
    
    
    /**
     Save session.
     
     - parameter token:    login token.
     - parameter username: login username.
     - parameter password: login password.
     */
    func save(token: String, username: String, password: String) {
        self.token = token
        signInDetails = (username, password)
    }
    
    /**
     Check if user is loged in.
     
     - returns: true if user is loged in.
     */
    func isLogedIn() -> Bool {
        if let token = token, !token.isEmpty {
            return true
        }
        
        return false
    }
    
    /**
     Check if login crudentials are saved.
     
     - returns: true if login crudentials are saved.
     */
    func isCrudentialsSaved() -> Bool {
        if signInDetails != nil {
            return true
        }
        
        return false
    }
    
}
