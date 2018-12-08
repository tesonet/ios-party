//
//  LoginResult.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation

struct LoginResult: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
