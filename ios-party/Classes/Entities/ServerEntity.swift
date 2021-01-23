//
//  ServerEntity.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import GRDB

class ServerEntity {
    
    // MARK: - Declarations
    var name: String
    var distance: Int
    
    // MARK: - Methods
    // MARK: - Initialization
    init?(from dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else {
            log("ERROR! Dictionary does not have name: \(dictionary)")
            return nil
        }
        
        guard let distance = dictionary["distance"] as? Int else {
            log("ERROR! Dictionary does not have distance: \(dictionary)")
            return nil
        }
        
        self.name = name
        self.distance = distance
    }
    
    // MARK: - FetchableRecord
    required init(row: Row) {
        name = row["name"]
        distance = row["distance"]
    }
    
    // MARK: - Helpers
    static func serverListFrom(dictList: [[String: Any]]) -> [ServerEntity] {
        
        var serverList: [ServerEntity] = []
        for serverDict in dictList {
            
            guard let server = ServerEntity(from: serverDict) else {
                log("ERROR! Could not parse ServerEntity from dictionary: \(serverDict)")
                continue
            }
            
            serverList.append(server)
        }
        
        return serverList
    }
}
