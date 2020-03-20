//
//  AuthorizedRequest.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

class AuthorizedRequest: HTTPHandlerRequest {
    
    func endPoint() -> String {
        return ""
    }
    
    func method() -> String {
        return "POST"
    }
    
    func parameters() -> Dictionary<String, Any>? {
        return nil
    }
    
    func headers() -> Dictionary<String, String> {
        var header = Dictionary<String, String>()
        header["Content-Type"] = "application/json"
        guard let authToken = Bindings.shared.authManager.authorizationHeader()?["token"] else { return header }
        header["Authorization"] = "Bearer " + authToken
        return header
    }
    
}

