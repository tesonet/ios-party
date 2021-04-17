//
//  AuthData.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation

struct AuthModel: Decodable {
    var token: String
}

struct ServerModel: Decodable {
    let name: String
    let distance: Int
}
