//
//  Server+CoreDataProperties.swift
//  testio
//
//  Created by Karolis Misiūra on 18/11/2017.
//  Copyright © 2017 Karolis Misiura. All rights reserved.
//
//

import Foundation
import CoreData

extension Server {

    public class func serverFetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: "Server")
    }
//
//    @NSManaged public var distance: Int16
//    @NSManaged public var name: String?
    
    enum ServerError: Error {
        case jsonDataMissingName
        case jsonDataMissingDistance
        case jsonDataDistanceMallformed
    }
    
    public static func with(name: String) -> Server? {
        let fetchRequest = Server.serverFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try ContextManager.viewContext.fetch(fetchRequest)
            return result.first
        } catch  {
            
        }
        
        return nil
    }
    
    public static func create(jsonData json: [String: Any]) throws -> Server {
        
        guard let name = json["name"] as? String else {
            throw ServerError.jsonDataMissingName
        }
        
        guard let distance = json["distance"] as? Int else {
            throw ServerError.jsonDataMissingDistance
        }
        
        let newServer = Server(context: ContextManager.viewContext)
        
        newServer.name = name
        newServer.distance = Int16(distance)
        
        return newServer
    }
    
    public static func importServers(_ jsonData: [[String: Any]]) {
        for data in jsonData {
            guard let name = data["name"] as? String else {
                continue
            }
            
            if let server = Server.with(name: name), let distance = data["distance"] as? Int {
                server.distance = Int16(distance)
            } else {
                do {
                    let _ = try Server.create(jsonData: data)
                } catch {
                    NSLog("Failed to create Server from json data \(data).\n With error: \(String(describing: error))")
                }
            }
            
        }
    }
}
