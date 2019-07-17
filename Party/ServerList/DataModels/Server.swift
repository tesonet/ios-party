//
//  Server.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

struct Server: Codable {
    
    let name: String
    
    let distance: Int
}

extension Server {
    
    static func get() -> Resource<[Server]> {
        return Resource<[Server]>.entity(.servers, method: .get)
    }
}
