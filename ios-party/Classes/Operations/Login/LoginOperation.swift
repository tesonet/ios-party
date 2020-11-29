//
//  LoginOperation.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import Alamofire
import Foundation

class LoginOperation {
    
    struct Constants {
        static let url = "https://playground.tesonet.lt/v1/tokens"
        
        static let usernameKey = "username"
        static let passwordKey = "password"
    }

    func request(with username: String, password: String) -> DataRequest {
        let credentials = requestCredentials(with: username, password: password)
        
        return AF.request(Constants.url,
                          method: .post,
                          parameters: credentials,
                          encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
    }
    
    private func requestCredentials(with username: String, password: String) -> [String: Any] {
        var credentials: [String: String] = [:]
        credentials[Constants.usernameKey] = username
        credentials[Constants.passwordKey] = password
        
        return credentials
    }
}
