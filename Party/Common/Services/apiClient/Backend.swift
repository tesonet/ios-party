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

struct Endpoint: RawRepresentable, ExpressibleByStringLiteral {
    
    // MARK: - RawRepresentable
    
    var rawValue: String
    
    init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    // MARK: - ExpressibleByStringLiteral
    
    init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
    
    func path() -> String {
        return rawValue
    }
}

extension Endpoint {
    
    /// Generates token. Http method: POST
    static let tokens: Endpoint = "/v1/tokens"
    
    /// Loads list of servers. Http method: GET
    static let servers: Endpoint = "/v1/servers"
}
