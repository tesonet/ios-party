//
//  DataStorageManager.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/30/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import CoreData

protocol DataChangeObserver {
    func serversChanged(_ servers: [Server])
}

protocol DataManager {
    func initStorage()
    func saveServers(_ servers: [Server])
    func deleteServers()
    func getServers() -> [Server]
    func addObserver(_ observer: DataChangeObserver)
    func removeAllObservers()
    func notifyObservers()
}

class DataStorageManager: DataManager {
    private var observers: [DataChangeObserver] = []
    private let persistentContainer = NSPersistentContainer(name: "AtlasTest")

    func initStorage() {
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            guard context.hasChanges else { return }
            do{
                try context.save()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    func deleteEntity(name: String) {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.executeAndMergeChanges(using: deleteRequest)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    func saveServers(_ servers: [Server]) {
        for server in servers {
            let _ = ServerEntity.from(server: server, context: persistentContainer.viewContext)
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    
    func deleteServers() {
        deleteEntity(name: "ServerEntity")
    }
    
    func getServers() -> [Server] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
        guard let serverEntities = try? context.fetch(request) else { return [] }
        var servers:[Server] = []
        for serverEntity in serverEntities {
            servers.append(serverEntity.toServer())
        }
        return servers
    }
    
    func addObserver(_ observer: DataChangeObserver) {
        observers.append(observer)
    }
    
    func removeAllObservers() {
        observers.removeAll()
    }
    
    func notifyObservers() {
        let servers = getServers()
        for observer in observers {
            observer.serversChanged(servers)
        }
    }
}

extension ServerEntity {
    static func from(server: Server, context: NSManagedObjectContext) -> ServerEntity {
        let serverEntity = ServerEntity(context: context)
        serverEntity.name = server.name
        serverEntity.distance = server.distance
        return serverEntity
    }
    
    func toServer() -> Server {
        return Server(name: self.name ?? "", distance: self.distance )
    }
}

extension NSManagedObjectContext {
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
