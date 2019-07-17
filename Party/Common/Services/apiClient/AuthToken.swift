//
//  AuthToken.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

struct AuthToken: Codable {
    
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}

extension AuthToken {
    
    struct Parameters {
        static let username = "username"
        static let password = "password"
    }
    
    /// Creates resource for API request to retrieve token.
    ///
    /// - Parameters:
    ///   - username: A username value to authenticate user.
    ///   - password: A password value to authenticate user
    /// - Returns: A resource for API request.
    static func get(username: String,
                    password: String) -> Resource<AuthToken> {
        let parameters = [Parameters.username: username,
                          Parameters.password: password]
        return Resource<AuthToken>.entity(.tokens,
                                          method: .post,
                                          parameters: parameters)
    }
}
