import Foundation
import CoreData
import UIKit

enum ServersStoreResult {
    case success(serverResponse: ServersResponse)
    case failure
}

final class ServersStore {
    
    func loadServers(completion: @escaping (ServersStoreResult) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Servers")
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            DispatchQueue.main.async {
                guard let result = asynchronousFetchResult.finalResult as? [NSManagedObject] else {
                    completion(.failure)
                    return
                }
                
                let servers = result.compactMap {
                    ServerDescription(
                        name: $0.value(forKey: "name") as! String,
                        distance: $0.value(forKey: "distance") as! Int
                    )
                }
                
                let serversResponse = ServersResponse(servers: servers)
                completion(.success(serverResponse: serversResponse))
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        do {
            try managedContext.execute(asynchronousFetchRequest)
        } catch {
            completion(.failure)
        }
    }
    
    func saveServers(serversResponse: ServersResponse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let serversEntity = NSEntityDescription.entity(forEntityName: "Servers", in: managedContext) else { return }
        
        for server in serversResponse.servers {
            let serverObject = NSManagedObject(entity: serversEntity, insertInto: managedContext)
            serverObject.setValue(server.name, forKey: "name")
            serverObject.setValue(server.distance, forKey: "distance")
        }
        
        do {
            try managedContext.save()
        } catch {
            () // fail silently
        }
    }
}
