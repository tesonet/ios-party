//
//  AuthenticationAPI.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

extension API.Authentication {
    
    struct Login: ModelTargetType, MethodPOST {
        typealias T = LoginResponse
        let loginForm: LoginForm
        var path: String { "tokens" }
        var parameters: [String: Any]? {
            return ["username": loginForm.username,
                    "password": loginForm.password]
        }
    }
}
