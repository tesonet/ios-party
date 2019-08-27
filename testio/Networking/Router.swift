//
//  Router.swift
//  testio
//
//  Created by Justinas Baronas on 12/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import Foundation


enum Router {
    
    var baseUrl: URL {
        return URL(string: K.Request.baseUrl)!
    }
    
    case getToken(username: String, password: String)
    case getServersList
    
    var scheme: String {
        switch self {
        default:
            return K.Request.scheme
        }
    }
    
    var host: String {
        switch self {
        default:
            return K.Request.host
        }
    }
    
    var path: String {
        switch self {
        case .getToken:
            return K.Request.tokens
        case .getServersList:
            return K.Request.servers
        
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .getToken(let username,let password):
            return [K.Credentials.username : username,
                    K.Credentials.password : password]
        case .getServersList:
            return nil
        }
    }
    
    var method: String {
        switch self {
        case .getToken:
            return K.Request.Method.post
        case .getServersList:
            return K.Request.Method.get
        }
    }
    
}
