//
//  DatabaseManager.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import CoreData

class DatabaseManager {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "database", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = makePersistentStoreCoordinator()
        return managedObjectContext
    }()
    
    // MARK: - Public Methods
    
    //Saving entities to core data.
    func save<T>(entities: [T]) where T: Mappable {
        managedObjectContext.perform { [unowned self] in
            entities.forEach {
                let dbEntity = NSEntityDescription.insertNewObject(forEntityName: T.entityName(),
                                                                   into: self.managedObjectContext)
                // Set attributes.
                $0.attributes().forEach { (attribute) in
                    dbEntity.setValue(attribute.value, forKey: attribute.name)
                }
            }
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // Loading entities from core data.
    func fetch<T>(_ entities: T.Type, completion: @escaping ([T]) -> Void) where T: Mappable {
        managedObjectContext.perform { [unowned self] in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName())
            do {
                if let objects = try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                    let entities = objects.map { T(managedObject: $0) }
                    completion(entities)
                } else {
                    completion([])
                }
            } catch {
                completion([])
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func makePersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        // load persistent stores
        let options: [AnyHashable: Any] = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[urls.count-1]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: documentsDirectory.appendingPathComponent("database.sqlite"),
                                               options: options)
        } catch {
            fatalError("failed to add persistent store")
        }
        return coordinator
    }
}

