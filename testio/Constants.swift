//
//  Constants.swift
//  testio
//
//  Created by Justinas Baronas on 11/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import UIKit


typealias Closures = (() -> Void)

/// Various Constants for whole project
enum K {
    
    /// API Request
    enum Request {
        static let baseUrl = "http://playground.tesonet.lt/v1"
        static let scheme = "http"
        static let host = "playground.tesonet.lt"
        
        static let servers = "/v1/servers"
        static let tokens = "/v1/tokens"
        
        
        enum HTTPHeaderField {
            static let authorization = "Authorization"
            static let contentType = "Content-Type"
            static let acceptType = "Accept"
            static let acceptEncoding = "Accept-Encoding"
        }
        
        enum Method {
            static let get = "GET"
            static let post = "POST"
        }
        
        enum ContentType {
            static let json = "application/json"
        }
    }
    
    enum Credentials {
        static let username = "username"
        static let password = "password"
        static let token = "token"
    }
    
    enum Style {
        static let buttonCornerRadius: CGFloat = 8
    }
    
}
