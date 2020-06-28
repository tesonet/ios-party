//
//  CoreDataManager.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/27/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var context:NSManagedObjectContext
    {
        get
        {
            persistentContainer.viewContext
        }
    }
    
    func getServers() -> [Server]
    {
        var servers = [Server]()
        let serversRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Server")
        do
        {
            servers = try context.fetch(serversRequest) as! [Server]
        }
        catch
        {
            print(error)
        }
        return servers
    }
    
    func writeServers(distance: Int16, name: String)
    {
        let entity = NSEntityDescription.entity(forEntityName:"Server",in: context)!
        let object = NSManagedObject(entity: entity,insertInto: context)
        object.setValue(distance, forKey: "distance")
        object.setValue(name, forKey: "name")
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Testio")
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
}
