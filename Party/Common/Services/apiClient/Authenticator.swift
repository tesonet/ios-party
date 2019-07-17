//
//  Authenticator.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

class Authenticator {
    
    // MARK: - Dependencies
    
    let tokenStorage: AuthTokenStorage
    
    // MARK: - Init
    
    init(tokenStorage: AuthTokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Public functions
    
    /// Creates authentication header with Bearer Token.
    ///
    /// - Parameter token: A token that is used to make authorization header.
    /// - Returns: A key value pair authorization header.
    func authenticationHeader() -> [String: String]? {
        guard let token = tokenStorage.retrieve() else {
            return nil
        }
        return ["Authorization":  "Bearer " + token.value]
    }
}
