//
//  ResponseParser.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResponseParser{
    
    static func isAuthorized(json : JSON) -> Bool{
        return json["message"] != "Unauthorized"
    }
    
    static func parseToken(json : JSON) -> String{
        return json["token"].stringValue
    }
    
    static func parseServers(json : JSON) -> [Server]{
        var serverList : [Server] = []
        for (_, subJson) : (String, JSON) in json{
            let server = Server()
            server.distance = subJson["distance"].intValue
            server.name = subJson["name"].stringValue
            serverList.append(server)
        }
        return serverList
    }
}
