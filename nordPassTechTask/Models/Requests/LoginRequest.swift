//
//  LoginRequest.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 13/04/2021.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}
