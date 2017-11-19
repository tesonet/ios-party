//
//  ContextManager.swift
//  testio
//
//  Created by Karolis Misiūra on 18/11/2017.
//  Copyright © 2017 Karolis Misiura. All rights reserved.
//

import Foundation
import CoreData

class ContextManager {
    
    static let sharedInstance = ContextManager()
    
    static var viewContext: NSManagedObjectContext {
        get {
            return ContextManager.sharedInstance.persistentContainer.viewContext
        }
    }
    
    private let persistentContainer: NSPersistentContainer
    
    private init(){
        let container = NSPersistentContainer(name: "testio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.persistentContainer = container
    }
    
    func resetStore() throws {
        let fetch = Server.serverFetchRequest()
        let request = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
        try ContextManager.viewContext.execute(request)
        try ContextManager.viewContext.save()
    }
}
