//
//  ServerCoreDataManager.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation
import CoreData

class ServerStorageManager: ServerStorageManagerProtocol {
    
    private let coreDataManager: CoreDataManager
    
    required init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func save(servers: [ServerModel], completion: @escaping ((Result<Bool, Error>) -> ())) {
        let backgroundContext = coreDataManager.newBackgroundContext
        
        backgroundContext.perform {
            let result: Result<[Server], Error> =
                self.coreDataManager.fetch(sortDesctiptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: nil, in: backgroundContext)
            switch result {
            case .success(let localServers):
                let updateResult = self.update(localServers: localServers, with: servers, in: backgroundContext)
                switch updateResult {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getServers(sorting: String, isAscending: Bool) -> Result<[Server], Error> {
        let sortDesriptor = NSSortDescriptor(key: sorting, ascending: isAscending)
        return coreDataManager.fetch(sortDesctiptors: [sortDesriptor], predicate: nil, in: coreDataManager.mainContext)
    }
    
    private func update(localServers: [Server], with servers: [ServerModel], in context: NSManagedObjectContext) -> Result<Bool, Error> {
        
        let localNames = localServers.compactMap({ $0.name })
        let newNames = servers.map({ $0.name })
        
        let serversToDelete = localServers.filter({
            let localName = $0.name ?? ""
            return !newNames.contains(localName)
        })
        
        let serversToSave = servers.filter({
            return !localNames.contains($0.name)
        })

        serversToDelete.forEach({
            self.coreDataManager.delete(item: $0, in: context)
        })
        
        var newServers = [Server]()
        serversToSave.forEach({
            let server: Server = self.coreDataManager.createItem(from: $0.props(), in: context)
            newServers.append(server)
        })
        
        return coreDataManager.save(context: context)
    }
}
