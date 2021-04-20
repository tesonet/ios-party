//
//  CoreDataManager.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation
import CoreData

final class CoreDataManager: CoreDataManagerProtocol {
    
    var mainContext: NSManagedObjectContext {
        return persistantContainer.viewContext
    }
    
    var newBackgroundContext:NSManagedObjectContext {
        return persistantContainer.newBackgroundContext()
    }
        
    func createItem<T: NSManagedObject>(from dic: [String: Any], in context: NSManagedObjectContext) -> T {
        let item: T = T(context: context)
        
        dic.keys.forEach({
            item.setValue(dic[$0], forKey: $0)
        })
        
        return item
    }

    func fetch<T: NSManagedObject>(sortDesctiptors: [NSSortDescriptor], predicate: NSPredicate?, in context: NSManagedObjectContext) -> Result<[T], Error> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDesctiptors
        
        do {
            let result = try context.fetch(request) as? [T] ?? [T]()
            return .success(result)
        } catch let error {
            return .failure(error)
        }
    }
    
    func save(context: NSManagedObjectContext) -> Result<Bool, Error> {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        do {
            try context.save()
            return .success(true)
        } catch let error {
            return .failure(error)
        }
    }
        
    func delete(item: NSManagedObject, in context: NSManagedObjectContext) {
        context.delete(item)
    }
        
    private lazy var persistantContainer: NSPersistentContainer = {
        let modelURL = Bundle(for: type(of: self)).url(forResource: "Servers", withExtension: "momd")
                
        guard let model = modelURL.flatMap(NSManagedObjectModel.init) else {
            fatalError("Failed to load core data model")
        }
        
        let container = NSPersistentContainer(name: "Servers", managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error: \(String(describing: error.localizedDescription))")
            }
        }
        
        return container
    }()
    
}
