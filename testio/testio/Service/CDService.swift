//
//  CDService.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation
import CoreData

class CDService {
    
    static let instance = CDService()
        
    private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "testio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    private init() {}
    
    func delete(objects: [NSManagedObject]) {
        for object in objects {
            context.delete(object)
        }
        save()
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch(sortBy: String) -> NSFetchedResultsController<NSFetchRequestResult>? {
        
        let fetchRequest: NSFetchRequest<Server> = Server.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        
        guard let controller = configureController(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: nil, cacheName: nil) else { return nil }
        
        return controller
        
    }
    
    func recordExists(serverName: String) -> Bool {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Server.fetchRequest()
        let namePredicate = NSPredicate(format: "\(Schema.Server.name) == %@", serverName)
    
        fetchRequest.predicate = namePredicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Schema.Server.name, ascending: true)]
        
        guard let controller = configureController(fetchRequest: fetchRequest, sectionNameKeyPath: nil, cacheName: nil) else { return false }
        
        if controller.fetchedObjects?.first != nil {
            return true
        }
        
        return false
        
    }
    
    private func configureController(fetchRequest:NSFetchRequest<NSFetchRequestResult>,
                                         sectionNameKeyPath: String? = nil,
                                         cacheName: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult>? {
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print ("\(error)")
        }
        
        return controller
        
    }
    
}
