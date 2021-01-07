
import UIKit
import CoreData


class ServersRepo {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "testio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Public
    func storeServers(_ servers: [Server]) {
        
        let context = persistentContainer.viewContext
        context.perform { [weak self] in
            
            let cdServers = self?.cdServers()
            cdServers?.forEach {
                context.delete($0)
            }
            try? context.save()
            
            
            servers.forEach {
                guard let entity = NSEntityDescription.entity(forEntityName: "CDServer", in: context) else {
                    return
                }
                let cdServer = NSManagedObject(entity: entity, insertInto: context)
                cdServer.setValue($0.name, forKey: "name")
                cdServer.setValue($0.distance, forKey: "distance")
                self?.saveContext()
            }
        }
    }
    
    func fetchServers(_ completion: @escaping (_ servers: [Server]) -> Void) {
        
        let context = persistentContainer.viewContext
        context.perform { [weak self] in
            let cdServers = self?.cdServers() ?? []
            let servers = cdServers.map { Server(name: $0.name,
                                                 distance: Int($0.distance)) }
            
            DispatchQueue.main.async {
                completion(servers)
            }
        }
    }
}


// MARK: - Private
private extension ServersRepo {
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func cdServers() -> [CDServer] {
        let request: NSFetchRequest<CDServer> = CDServer.fetchRequest()
        
        do {
            let cdServers = try context.fetch(request)
            return cdServers
        } catch {
            return []
        }
    }
}
