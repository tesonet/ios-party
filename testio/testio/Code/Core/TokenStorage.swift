//
//  TokenStorage.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import SAMKeychain

class TokenStorage {
    private let service = "Tesonet"
    private let account = "ServerList"
    
    var token: String? {
        set {
            guard let token = newValue else {
                SAMKeychain.deletePassword(forService: self.service, account: self.account)
                return
            }
          
            var error: NSError?
            
            SAMKeychain.setPassword(token, forService: self.service, account: self.account, error: &error)
            
            if let error = error {
                print(error)
            }
        }
        get {
            return SAMKeychain.password(forService: self.service, account: self.account)
        }
    }
}
