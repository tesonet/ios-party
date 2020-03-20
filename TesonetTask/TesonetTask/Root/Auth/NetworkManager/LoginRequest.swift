//
//  LoginRequest.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class LoginRequest: HTTPHandlerRequest {
    
    let params: Dictionary<String, Any>
    
    init(with params: Dictionary<String, Any>) {
        self.params = params
    }
    
    func endPoint() -> String {
        return "tokens"
    }
    
    func method() -> String {
        return "POST"
    }
    
    func parameters() -> [String : Any]? {
        return params
    }
    
    func headers() -> [String : String] {
        return ["Content-Type": "application/json"]
    }

}
