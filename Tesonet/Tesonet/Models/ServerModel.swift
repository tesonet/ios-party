//
//  ServerModel.swift
//  Tesonet
//

import Foundation

class ServerModel {

    let serverName: String
    let distanceToServer: Int

    init?(with dict: [String: Any]?) {
        guard let dict = dict, let name = dict["name"] as? String, let distance = dict["distance"] as? Int else {
            return nil
        }
        serverName = name
        distanceToServer = distance
    }
}
