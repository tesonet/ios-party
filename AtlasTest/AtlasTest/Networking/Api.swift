//
//  Api.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
}

enum Api {
    case getAccessToken(username: String, password: String)
    case getServers
}

extension Api: Endpoint {
    var method: HTTPMethod {
        switch self {
        case .getAccessToken: return .post
        case .getServers: return .get
        }
    }
    var path: String {
        switch self {
        case .getAccessToken: return AppConstants.Api.baseURL + AppConstants.Api.getAccessToken
        case .getServers: return AppConstants.Api.baseURL + AppConstants.Api.getServers
        }
    }
    var httpHeaders: [String: String] {
        switch self {
        case .getAccessToken: return postHeaders()
        case .getServers: return getHeaders()
        }
    }
    var parameters: [String: String] {
        switch self {
        case .getAccessToken: return [:]
        case .getServers: return [:]
        }
    }
    var body: [String: AnyObject] {
        switch self {
        case .getAccessToken(let username, let password):
            return ["username": username as AnyObject, "password": password as AnyObject]
        case .getServers:
            return [:]
        }
    }
    private func getHeaders() -> [String: String] {
        let token = LocalStorage.getToken() ?? ""
        return ["Accept": "application/json", "Authorization": "Bearer \(String(describing: token))"]
    }
    
    private func postHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    private func deleteHeaders() -> [String: String] {
        return ["Accept": "application/json"]
    }
}

extension String {
    var urlQueryEncoded: String {
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedString ?? self
    }
}
