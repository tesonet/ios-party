//
//  KeychainManager.swift
//  PartySwift
//
//  Created by Arturas Kuciauskas on 25.11.2019.
//  Copyright © 2019 Party. All rights reserved.
//

import UIKit

class KeychainManager: NSObject
{
    static let serviceName = "PartyService"
    
    class func readCredentialsFromKeychain(_ user: String) throws -> (String)
    {
        let password = try KeychainPasswordItem(service: serviceName, account: user).readPassword()
        
        return password
    }
    
    class func saveCredentialsToKeychain(_ user: String, password: String) throws
    {
      try KeychainPasswordItem(service: serviceName, account: user).savePassword(password)
    }
    
    

}
