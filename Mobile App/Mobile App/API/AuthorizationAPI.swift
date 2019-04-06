//
//  AuthorizationAPI.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation

extension API.Authorization {
    
    struct Login: ModelTargetType, MethodPOST {
        typealias T = Auth
        
        let username, password: String
        
        var path: String { return "/tokens" }
        
        var parameters: [String : Any]? {
            return ["username": username, "password": password]
        }
    }
    
    
}
