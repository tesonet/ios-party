//
//  Credentials.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation

struct Credentials: Codable {
    let username: String
    let password: String
    
    var asDict: [String: String] {
        return ["username": username, "password": password]
    }
}

struct Token: Decodable {
    let token: String
}

struct ErrorMessage: Decodable {
    let message: String
}
