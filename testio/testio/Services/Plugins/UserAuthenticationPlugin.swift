//
//  UserAuthenticationPlugin.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import Moya
import Result

/// Logs out user if any request returns Unauthorized (401)
public final class UserAuthenticationPlugin: PluginType {
    
    public init() {
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
        switch result {
        case let .success(moyaResponse):
            
            if target.path != TesonetAPI.login(LoginRequest(username: "", password: "")).path {
                if moyaResponse.statusCode == 401 { // Unauthorized
                    Notification.logOut.post()
                }
            }
        default:
            break
        }
    }
}
