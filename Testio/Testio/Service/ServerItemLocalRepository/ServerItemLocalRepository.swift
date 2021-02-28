//
//  LocalStorageService.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation
import CoreData

final class ServerItemLocalRepository {
    
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

extension ServerItemLocalRepository: ServerItemLocalRepositoryProtocol {
    
    func load(sortBy: ServerItemLocalRepositorySortOption, completion: ((Result<[DomainServerItem], LocalRepositoryError>) -> ())?) {
        let context = container.viewContext
        context.perform {
            let request: NSFetchRequest<ServerEntity> = ServerEntity.fetchRequest()
            
            let sort: NSSortDescriptor
            switch sortBy {
            case .name:
                sort = NSSortDescriptor(keyPath: \ServerEntity.name, ascending: true)
            case .distance:
                sort = NSSortDescriptor(keyPath: \ServerEntity.distance, ascending: true)
            }
            request.sortDescriptors = [sort]
            
            let result: Result<[DomainServerItem], LocalRepositoryError>
            do {
                let entities = try context.fetch(request)
                let items = entities.map { entity in
                    DomainServerItem(
                        name: entity.name ?? "",
                        distance: Int(entity.distance)
                    )
                }
                
                result = .success(items)
            } catch {
                result = .failure(.dataNotLoaded)
            }
            
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    func save(items: [DomainServerItem], completion: ((Result<Void, LocalRepositoryError>) -> ())?) {
        container.performBackgroundTask { context in
            let result: Result<Void, LocalRepositoryError>
            do {
                //XCTest does not support NSBatchDeleteRequest
                let request: NSFetchRequest<ServerEntity> = ServerEntity.fetchRequest()
                let entities = try context.fetch(request)
                entities.forEach { context.delete($0) }
            
                items.forEach { item in
                    let entity = ServerEntity(context: context)
                    entity.name = item.name
                    entity.distance = Int32(item.distance)
                }
            
                try context.save()
                result = .success(())
            } catch {
                result = .failure(.dataNotSaved)
            }
            
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    func clear() {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<NSFetchRequestResult> = ServerEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            _ = try? context.execute(deleteRequest)
        }
    }
}
