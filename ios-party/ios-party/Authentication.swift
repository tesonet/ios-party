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
    
    func login(username: String, password: String, completion: @escaping (String?) -> Void) {
        
        let body = ["username":username, "password":password]
        
        request.dataTask(withPath: loginPath, method: .post, body: body, tokenRequired: false) { object, error in
            var message: String? = "Sorry, something went wrong..."
            
            if let dictionary = object as? NSDictionary {
                if let token = dictionary["token"] as? String {
                    UserDefaults.standard.set(token, forKey: Keys.tokenKey)
                    message = nil
                } else if let returnedMessage = dictionary["message"] as? String {
                    message = returnedMessage
                }
            }
            completion(message)
        }
    }
}
