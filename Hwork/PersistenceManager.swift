//
//  PersistenceManager.swift
//  Hwork
//
//  Created by Robert P. on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import Foundation
import CoreData


final class PersistenceManager {
    
    static let sharedInstance = PersistenceManager()
    
    // MARK: - Core Data stack
     lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Hwork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
       
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

    func createServerEntity(dictionary: [String: Any]) -> NSManagedObject? {
        
        let context = PersistenceManager.sharedInstance.persistentContainer.viewContext
        if let serverEntity = NSEntityDescription.insertNewObject(forEntityName: "Server", into: context) as? Server {
            serverEntity.name = dictionary[Const.Response.serversList.nameKey] as? String ?? "N/A"
            serverEntity.distance = dictionary[Const.Response.serversList.distanceKey] as? Int16 ?? 0
            return serverEntity
        }
        return nil
    }
    
    func saveToCoreData(array: [[String: Any]]) -> Bool {
        
        _ = array.map{self.createServerEntity(dictionary: $0)}
        do {
            try PersistenceManager.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
            return false
        }
        return true
    }
    
    func deleteAllData() {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Server")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        request.resultType = .resultTypeObjectIDs
        do {
            let result = try persistentContainer.viewContext.execute(request) as? NSBatchDeleteResult
            if let deletedObjectIDs = result?.result as? [NSManagedObjectID] {
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                    into: [self.persistentContainer.viewContext])
            }
        } catch {
            print ("There was an error")
        }
        self.saveContext()
    }
    
}
