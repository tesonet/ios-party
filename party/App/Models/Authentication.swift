//
//  Authentication.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

struct LoginForm: Equatable {
    let username: String
    let password: String
}

struct LoginResponse: Codable, Equatable {
    let token: String
}
