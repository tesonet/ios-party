//
//  Constants.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/26/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import Foundation

struct Constants
{
    static let tokensURL = "https://playground.tesonet.lt/v1/tokens"
    static let serversURL = "https://playground.tesonet.lt/v1/servers"
    
    static let ServersViewTableViewCellID = "tesio.serversView.tableViewCellID"
    static let keychainPasswordKey = "tesio.keychainManager.password"
    static let keychainUsernameKey = "tesio.keychainManager.username"
    static let keychainTokenKey = "tesio.keychainManager.token"
}

enum CredentialsKey
{
    case username
    case password
    case token
}
