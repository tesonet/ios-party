//
//  ServerListEntity.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation

class ServerListEntity: Equatable {
    
    let name: String
    let distance: Int
    
    init?(jsonData: [String: Any]) {
        guard let name = jsonData["name"] as? String,
              let distance = jsonData["distance"] as? Int else {
            return nil
        }
        
        self.name = name
        self.distance = distance
    }
    
    static func listFrom(dictList: [[String: Any]]) -> [ServerListEntity] {
        
        var serverList: [ServerListEntity] = []
        for serverDictionary in dictList {
            if let server = ServerListEntity(jsonData: serverDictionary) {
                serverList.append(server)
            }
        }
        
        return serverList
    }
    
    // MARK: - Equatable
    static func == (lhs: ServerListEntity, rhs: ServerListEntity) -> Bool {
        return lhs.name == rhs.name && lhs.distance == rhs.distance
    }
}
