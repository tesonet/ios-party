//
//  Headers.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

extension API.Headers {
    
    static var token: String? {
        return KeychainManager.shared.getToken()
    }
    
    static var all: [String: String] {
        var headers: [String: String] = [:]
        if let token = token { headers["Authorization"] = "Bearer \(token)" }
        return headers
    }
}
