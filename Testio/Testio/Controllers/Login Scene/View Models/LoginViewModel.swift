//
//  LoginViewModel.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import Alamofire

class LoginViewModel: NSObject {
    typealias LoginResponseHandler = (Bool, String?) -> Void
    let loginService: LoginService
    
    var isLoggedIn: Bool {
        return ApiSessionHandler.sharedInstance.isLoggedIn
    }
    
    override init() {
        self.loginService = LoginService()
        super.init()
    }

    func login(with credentials: Credentials, completion: @escaping LoginResponseHandler) {
        loginService.login(with: credentials) { loginResponse in
            guard let token = loginResponse.token else {
                completion(false, loginResponse.errorMessage)
                return
            }
            ApiSessionHandler.sharedInstance.set(authToken: token.token)
            completion(true, nil)
        }
    }
    
    func getCredentials(username: String?, password: String?) throws -> Credentials {
        guard let username = username, !username.isEmpty else {
            throw LoginError.usernameEmpty
        }
        
        guard let password = password, !password.isEmpty else {
            throw LoginError.passwordEmpty
        }
        
        return Credentials(username: username, password: password)
    }
}

enum LoginError: Error {
    case usernameEmpty
    case passwordEmpty
    
    var message: String {
        return "Username and password can not be empty."
    }
}
