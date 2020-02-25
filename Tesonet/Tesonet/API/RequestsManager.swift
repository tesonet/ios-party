//
//  RequestsManager.swift
//  Tesonet
//
//  Created by Александр on 2/25/20.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Alamofire

enum RequestsManager: APIProtocol {

    case login(userName: String, password: String)
    case serversList(token: String)

    var baseUrl: String {
        return ""
    }

    func requestType() -> HTTPMethod {
        switch self {
        case .login:
            return .post
        case .serversList:
            return .get
        }
    }
    
    func endpoint() -> String {
        switch self {
        case .login:
            return "tokens"
        case .serversList:
            return "servers"
        }
    }
    
    func params() -> [String : Any]? {
        switch self {
        case let .login(userName, password):
            return ["username": userName, "password": password]
        default:
            return nil
        }
    }
    
    func headers() -> [String : String] {
        switch self {
        case let .serversList(token):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
