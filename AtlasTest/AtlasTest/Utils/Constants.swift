//
//  Constants.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

struct AppConstants {
    struct Api {
        static let baseURL = "http://playground.tesonet.lt/"
        static let getAccessToken = "v1/tokens"
        static let getServers = "v1/servers"
    }
    struct ServersList {
        static let tableServerTitle = "SERVER"
        static let tableDistanceTitle = "DISTANCE"
        static let serversTableHeaderId = "ServersTableHeader"
    }
}
