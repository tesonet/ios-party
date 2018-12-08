//
//  PersistentContainer.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 07/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer {
    
    static let shared = PersistentContainer()
    
    private init() {
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "testio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAll<ResultType>(withRequest request: NSFetchRequest<ResultType>) where ResultType: NSManagedObject {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            // TODO: Handle error appropriately
            print ("\(error)")
        }
    }
    
    func fetch<ResultType>(withRequest request: NSFetchRequest<ResultType>, sortBy: String) -> NSFetchedResultsController<ResultType>? where ResultType: NSManagedObject {
        request.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        guard let controller = fetchWithController(fetchRequest: request, sectionNameKeyPath: nil, cacheName: nil) else {
            return nil
        }
        
        return controller
    }
    
    func updateFetch<ResultType>(sortBy: String, for controller: NSFetchedResultsController<ResultType>) where ResultType: NSManagedObject {
        controller.fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        performFetch(using: controller)
    }
    
    private func fetchWithController<ResultType>(fetchRequest: NSFetchRequest<ResultType>,
                                                 sectionNameKeyPath: String? = nil,
                                                 cacheName: String? = nil) -> NSFetchedResultsController<ResultType>? where ResultType: NSFetchRequestResult {
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
        performFetch(using: controller)
        
        return controller
    }
    
    private func performFetch<ResultType>(using controller: NSFetchedResultsController<ResultType>) where ResultType: NSFetchRequestResult {
        do {
            try controller.performFetch()
        } catch {
            // TODO: Handle error appropriately
            print ("\(error)")
        }
    }
}
