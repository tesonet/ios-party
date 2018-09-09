//
//  PersistenceStore.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import CoreData

class PersistenceStore {
    var viewContext: NSManagedObjectContext {
        get {
            return self.persistentContainer.viewContext
        }
    }
    private let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "Model")
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    func resetStore(in context: NSManagedObjectContext) {
        let fetchRequest = Server.serverFetchRequest()
        
        let servers = try? context.fetch(fetchRequest)
        servers?.forEach { context.delete($0) }
        
        try? context.save()
    }
}
