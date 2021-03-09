//
//  Endpoint.swift
//  Testio
//
//  Created by Andrii Popov on 3/7/21.
//

import Foundation

enum Endpoint {
    case logIn(user: String, password: String)
    case servers(token: String)
}

extension Endpoint {
    
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components.url!
    }
    
    var path: String {
        switch self {
        case .logIn:
            return "/v1/tokens"
        case .servers:
            return "/v1/servers"
        }
    }
    
    var host: String {
        "playground.tesonet.lt"
    }
    
    var scheme: String {
        switch self {
        case .logIn:
            return "https"
        case .servers:
            return "http"
        }
    }
    
    var headers: [String: String] {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .servers(let token):
            headers["Authorization"] = "Bearer \(token)"
        default:
            break
        }
        return headers
    }
    
    var body: Data? {
        switch self {
        case .logIn(let user, let password):
            return try? JSONSerialization.data(withJSONObject: ["username": user, "password": password], options: .prettyPrinted)
        case .servers:
            return nil
        }
    }

}
