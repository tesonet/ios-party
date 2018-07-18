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
	
    func signOut(forgetLogin: Bool) {
        token = nil
        if forgetLogin {
            signInDetails = nil
        }
	}
    
}
