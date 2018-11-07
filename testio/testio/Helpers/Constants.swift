//
//  Constants.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation

let USER_LOGGED_IN = "USER_LOGGED_IN"
let MY_PASSWORD = "MY_PASSWORD"
let MY_USERNAME = "MY_USERNAME"

struct StoryboardID {
    private init() {}
    
    static let logInVC = "LogInVC"
    static let serverListVC = "ServerListVC"
}

struct TesonetAPI {
    private init() {}
    
    static let baseUrl = "http://playground.tesonet.lt/v1/"
    static let serversUrl = baseUrl+"servers"
    static let tokensUrl = baseUrl+"tokens"
    static let header = ["Content-Type":"application/json; charset=utf-8"]
    static let bearer_header = ["Authorization": "Bearer \(DataService.instance.authToken ?? "")",
                                "Content-Type":"application/json; charset=utf-8"]
    
}

struct Schema {
    private init() {}
    
    struct Authorization {
        static let username = "username"
        static let password = "password"
    }
    
    struct Server {
        static let distance = "distance"
        static let name = "name"
    }
    
}

struct Cell {
    static let serverCell = "ServerCell"
}
