//
//  UserLoginManager.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import AFNetworking

enum UserLoginManagerError: Error {
    case incorrectUserNameOrPassword
}

class UserLoginManager {
    private let HTTPSessionManager: AFHTTPSessionManager
    
    init(HTTPSessionManager: AFHTTPSessionManager) {
        self.HTTPSessionManager = HTTPSessionManager
    }
    
    func login(using username: String, and password: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters = ["username": username,
                          "password": password]
        
        self.HTTPSessionManager.post("tokens", parameters: parameters, headers: nil, progress: nil, success: { (task, object) in
            guard let object = object as? Dictionary<String, String> else {
                completion(nil, UserLoginManagerError.incorrectUserNameOrPassword)
                return
            }
            
            if let token = object["token"] {
                completion(token, nil)
                return
            }
            
            completion(nil, UserLoginManagerError.incorrectUserNameOrPassword)
        }) { (task, error) in
            completion(nil, error)
        }
    }
}
