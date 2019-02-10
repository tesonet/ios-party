//
//  LoginResponse.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation

struct LoginResponse {
    var token: Token?
    var errorMessage: String?
    
    init(token: Token) {
        self.token = token
    }
    
    init(error: ServiceError) {
        switch error {
        case .invalidCredentails(text: let message):
            self.errorMessage = message
        default:
            break
        }
    }
}
