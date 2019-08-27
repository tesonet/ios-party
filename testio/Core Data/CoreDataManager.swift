//
//  CoreDataStorage.swift
//  testio
//
//  Created by Justinas Baronas on 25/08/2019.
//  Copyright © 2019 Justinas Baronas. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() { }
    
    
    func save(_ servers: [Server]) {
      persistentContainer.performBackgroundTask { (context) in
            servers.forEach { server in
                let serverEntity = ServerEntity(context: context)
                serverEntity.name = server.name
                serverEntity.distance = Int32(server.distance)
            }
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func getServers(completion: @escaping (([Server]) -> ())) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServerEntity")
        let privateManagedObjectContext = persistentContainer.newBackgroundContext()
        
        
        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            guard let result = asynchronousFetchResult.finalResult as? [ServerEntity] else { return }
            let servers = result.compactMap { Server(name: $0.name ?? "",
                                                     distance: Int($0.distance))}
            // Dispatches to use the data in the main queue
            DispatchQueue.main.async {
                completion(servers)
            }
        }
        
        do {
            try privateManagedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "testio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   
}
