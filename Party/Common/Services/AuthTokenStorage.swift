//
//  AuthTokenStorage.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

class AuthTokenStorage {
    
    // MARK: Constants
    
    static let authTokenKey: String = "authTokenKey"
    
    // MARK: Dependencies
    
    let storage: UserDefaults
    
    // MARK: - Init
    
    init(storage: UserDefaults = UserDefaults.standard) {
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    func store(_ token: AuthToken?, forKey key: String = authTokenKey) {
        guard let token = token else {
            storage.set(nil, forKey: key)
            storage.synchronize()
            return
        }
        let data = try? JSONEncoder().encode(token)
        storage.set(data, forKey: key)
        storage.synchronize()
    }
    
    func retrieve(forKey key: String = authTokenKey) -> AuthToken? {
        guard let data = storage.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(AuthToken.self, from: data)
    }
    
    func clear(forKey key: String = authTokenKey) {
        store(nil, forKey: key)
    }
}
