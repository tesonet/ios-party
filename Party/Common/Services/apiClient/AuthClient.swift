//
//  AuthClient.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit
import Alamofire

class AuthClient {
    
    enum Result {
        case success(String)
        case failure(Error)
    }
    
    // MARK: - Dependancies
    
    private var sessionManager: Alamofire.SessionManager
    
    // MARK: - State
    
    /// The base url of the authentication server.
    var baseUrl: URL
    
    // MARK: Init
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
        self.sessionManager = Alamofire.SessionManager.default
    }
    
    // MARK: Authentication
    
    /// A method for authentication with provided username and password.
    ///
    /// - Parameters:
    ///   - username: A username value to authenticate user.
    ///   - password: A password value to authenticate user
    ///   - completion: A result block after authentication process.
    func authenticate(with username: String, password: String, completion: @escaping (_ result: Result) -> Void) {
        let url = baseUrl.appendingPathComponent(Endpoint.tokens.path())
        
        var acceptedStatusCodes: [Int] = Array(200..<300)
        acceptedStatusCodes += [400, 500]
        
        let parameters = ["username": username, "password": password]
        
        // Performe a request.
        sessionManager.request(url, method: .post, parameters: parameters)
            .validate(statusCode: acceptedStatusCodes)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                let result: Result = .success("test")
                
                switch response.result {
                case .success:
                    print("\(String(data: response.data!, encoding: .utf8))")
                case .failure:
                   print("\(response.error?.localizedDescription)")
                }
                
                completion(result)
        }
    }
}
