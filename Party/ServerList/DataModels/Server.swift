//
//  Server.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation
import CoreData

struct Server {
    
    let name: String
    
    let distance: Int
    
    /// An object id representing entity in databse.
    var managedObjectID: NSManagedObjectID?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case distance
    }
}

extension Server: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Server.CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let distance = try container.decode(Int.self, forKey: .distance)
        
        self.init(name: name,
                  distance: distance,
                  managedObjectID: nil)
    }
}

extension Server {
    
    static func get() -> Resource<[Server]> {
        return Resource<[Server]>.entity(.servers, method: .get)
    }
}

extension Server: Mappable {
    
    init(managedObject: NSManagedObject) {
        guard let entity = managedObject as? ServerEntity else {
            fatalError("Tried to load invalid entity")
        }
        self.init(name: entity.name!,
                  distance: Int(entity.distance),
                  managedObjectID: entity.objectID)
    }
    
    func attributes() -> [Attribute<Any>] {
        return [
            Attribute(name: "name", value: name),
            Attribute(name: "distance", value: distance)
        ]
    }

    static func entityName() -> String {
        return "ServerEntity"
    }
}
