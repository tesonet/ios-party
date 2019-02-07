//
//  Constants.swift
//  Hwork
//
//  Created by Robertas Pauzas on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import UIKit

struct Const {
    
    private init() {}
    
    static let sizeMultiplyer = UIScreen.main.bounds.width/320
    
    struct Request {
        
        private static let baseUrl = "http://playground.tesonet.lt/v1/"
        
        struct auth {
            static let url = baseUrl + EndPoint.auth.rawValue
            static let method = "POST"
            static let userNameKey = "username"
            static let passwordKey = "password"
        }
        
        struct serversList {
            static let url = baseUrl + EndPoint.serversList.rawValue
            static let method = "GET"
            static let headerKey = "Authorization"
            static let headerValuePrefix = "Bearer "
        }
    }
    
    struct Response {
        
        enum ErrorStatus: String {
            case unauthorized = "User is not authozed or bad credentials"
            case other = "Server error"
            case noCredentials = "Username or password is missing"
        }
        
        struct auth {
            static let tokenKey  = "token"
        }
        
        struct serversList {
            static let nameKey      = "name"
            static let distanceKey  = "distance"
        }
        
    }
    
    struct Keychain {
        static let accessToken = "access_token"
    }
    
    struct Segues {
        static let serversSegue = "serversSegue"
    }
    
    struct Cells {
        static let serverCellIdentifier = "serverCell"
        
        static let headerCellIdentifier = "HeaderView"
    }
    
    static let spinnerViewTag = 10
}


private extension Const {
    
    enum EndPoint: String {
        case auth = "tokens"
        case serversList = "servers"
    }
    
}

