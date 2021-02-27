//
//  AuthenticationStorage.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

final class AuthenticationStorage: AuthenticationStorageDelegate {
    
    static var shared = AuthenticationStorage()
    
    func didUpdateAuthentication(_ authentication: Authorizable) {
        UserDefaults.standard.set(authentication.accessToken, forKey: "TOKEN")
    }
    
    func authentication() -> Authorizable {
        let token = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
        return Authentication(accessToken: token, tokenType: "Bearer")
    }
    
    var isLoggedIn: Bool {
        UserDefaults.standard.string(forKey: "TOKEN") != nil
    }
    
    func clearData() {
        UserDefaults.standard.set(nil, forKey: "TOKEN")
    }
}

struct Authentication: Authorizable {
    var accessToken: String
    var tokenType: String
}
