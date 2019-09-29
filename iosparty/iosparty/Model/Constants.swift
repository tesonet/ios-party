//
//  Constants.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation

struct Constants {
    //API URL's
    static let TOKENS_URL = "http://playground.tesonet.lt/v1/tokens"
    static let SERVERS_URL = "http://playground.tesonet.lt/v1/servers"
    
    //Keychain keys
    static let USER_TOKEN_KEY = "usertoken"
    
    //Segue identifiers
    static let LOGIN_SEGUE = "loginSegue"
    static let MAIN_SCREEN_SEGUE = "mainScreenSegue"
    
    //Cell identifiers
    static let SERVER_TABLE_CELL = "serverTableCell"
    
    //Icon names
    static let USER_NAME_ICON = "ico-username"
    static let LOCK_ICON = "ico-lock"
}
