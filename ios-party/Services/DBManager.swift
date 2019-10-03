//
//  DBManager.swift
//  ios-party
//
//  Created by Артём Зиньков on 10/2/19.
//  Copyright © 2019 Artem Zinkov. All rights reserved.
//

import CoreData

final class DBManager {
    
    public static let shared = DBManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ios_party")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private lazy var viewContext = persistentContainer.viewContext
    private let modelName = "Server"
    
    func getServers() -> [Server]? {
        let fetchRequest = NSFetchRequest<Server>(entityName: modelName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            Router.route(to: .Error(description: error.localizedDescription))
        }
        
        return nil
    }
    
    func save(_ model: ServerModel) {

        let fetchRequest = NSFetchRequest<Server>(entityName: modelName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "(serverName == %@)", model.name)
        var models: [Server]? = []
        
        do {
            models = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            Router.route(to: .Error(description: error.localizedDescription))
        }
        
        if let server = models?.first {
            server.setValue(model.distance, forKeyPath: "distance")
        } else {
            let entity = NSEntityDescription.entity(forEntityName: modelName, in: viewContext)!
            let server = models?.first ?? NSManagedObject(entity: entity, insertInto: viewContext)
            
            server.setValue(model.name, forKeyPath: "serverName")
            server.setValue(model.distance, forKeyPath: "distance")
        }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            Router.route(to: .Error(description: error.localizedDescription))
        }
        
    }
}
