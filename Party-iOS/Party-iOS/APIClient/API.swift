//
//  API.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

enum API {
    case authenticate(username: String, password: String)
    case list
}

extension API: EndPoint {
    
    var headers: Headers? { nil }
    
    var baseURL: URL {
        URL(string: "https://playground.tesonet.lt/v1")!
    }
    
    var path: String {
        switch self {
        case .authenticate:
            return "/tokens"
        case .list:
            return "/servers"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        case .list:
            return .get
        }
    }
    
    var parameterEncoding: HTTPParameterEncoding {
        switch self {
        case .authenticate:
            return .json
        case .list:
            return .json
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .authenticate(let username, let password):
            return .parameters(["username": username, "password": password])
        case .list:
            return .plain
        }
    }
}
