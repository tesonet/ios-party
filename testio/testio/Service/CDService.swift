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
    
    enum SortMethod: String {
        case byName = "name"
        case alphanumeric = "distance"
    }
    
    private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "testio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    private init() {}
    
    public func delete(objects: [NSManagedObject]) {
        for object in objects {
            context.delete(object)
        }
        save()
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch(sortBy: SortMethod) -> NSFetchedResultsController<Server>? {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Server.fetchRequest()
        let sortDescriptor = configureSortDescriptor(sortBy: sortBy)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
            return controller as? NSFetchedResultsController<Server>
        } catch {
            let error = error as NSError
            debugPrint("\(error)")
            return nil
        }
        
    }
    
    public func recordExists(serverName: String) -> Bool {
        
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
    
    private func configureSortDescriptor(sortBy: SortMethod) -> NSSortDescriptor {
        return NSSortDescriptor(key: sortBy.rawValue, ascending: true)
    }
    
}
