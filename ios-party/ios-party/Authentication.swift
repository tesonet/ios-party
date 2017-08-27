//
//  Authentication.swift
//  ios-party
//
//  Created by Adomas on 27/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import Foundation

class Authentication {
    
    private let request = Request()
    private let loginPath = "tokens"
    
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        let body = ["username":username, "password":password]
        
        request.dataTask(withPath: loginPath, method: .post, body: body, tokenRequired: false) { object, error in
            var message = "Sorry, something went wrong..."
            var success = false
            
            if let dictionary = object as? NSDictionary {
                if let token = dictionary["token"] as? String {
                    UserDefaults.standard.set(token, forKey: Constants.tokenKey)
                    success = true
                } else if let returnedMessage = dictionary["message"] as? String {
                    message = returnedMessage
                }
            }
            completion(success, message)
        }
    }
}
