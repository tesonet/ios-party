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
        case success(token: AuthToken)
        case failure(error: Error)
    }
    
    // MARK: - Dependancies
    private let apiClient: ApiClient
    private var sessionManager: Alamofire.SessionManager
    
    // MARK: - State
    
    /// The base url of the authentication server.
    var baseUrl: URL
    
    // MARK: Init
    
    init(baseUrl: URL, apiClient: ApiClient) {
        self.apiClient = apiClient
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
    func authenticate(with username: String,
                      password: String,
                      completion: @escaping (_ result: Result) -> Void) {
        let resource = AuthToken.get(username: username, password: password)
    
        apiClient.load(resource,
                       success: { (token) in
                        if let token = token {
                            completion(.success(token: token))
                        } else {
                            //completion(.failure(error: error))
                        }
        }, failure: { (error) in
            completion(.failure(error: error))
        })
    }
}
