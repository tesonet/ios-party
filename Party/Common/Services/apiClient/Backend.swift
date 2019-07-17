//
//  Backend.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

struct Backend {
    /// The base URL of the backend.
    static let baseUrl = URL(string: "http://playground.tesonet.lt")!
}

struct Endpoint {
    
    // MARK: - RawRepresentable
    
    var rawValue: String
    
    init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Endpoint {
    
    /// Generates token. Http method: POST
    static let tokens = "/v1/tokens"
    
    /// Loads list of servers. Http method: GET
    static let servers = "/v1/servers"
}
