//
//  Config.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation


enum ApiEndpoint {
    case login(username: String, password: String)
    case servers(token: String)
}

extension ApiEndpoint {
    var url: URL {
        var components = URLComponents()
        components.path = path
        components.scheme = scheme
        components.host = host
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    var body: Data? {
        switch self {
        case .servers: return nil
        case .login(let username, let password):
            return try? JSONSerialization.data(withJSONObject: ["username": username, "password": password], options: .prettyPrinted)
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
    
    private var path: String {
        switch self {
        case .login: return "/v1/tokens"
        case .servers: return "/v1/servers"
        }
    }
    
    private var host: String {
        return "playground.tesonet.lt"
    }
    
    private var scheme: String {
        switch self {
        case .login: return "https"
        case .servers: return "https"
        }
    }
}
