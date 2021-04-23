//
//  StorageService.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation

final class StorageService: StorageServiceProtocol {
    
    private var serverStorageManager: ServerStorageManager
    
    required init(serverStorageManager: ServerStorageManager) {
        self.serverStorageManager = serverStorageManager
    }
    
    func save(servers: [ServerModel], completion: @escaping ((Result<Bool, Error>) -> ())) {
        
        serverStorageManager.save(servers: servers, completion: completion)
    }
    
    func getServers(sortingMethod: SortingMethod) -> Result<[ServerModel], Error> {
        let key = sortingMethod == .alphanumerical ? "name" : "distance"
        
        let result = serverStorageManager.getServers(sorting: key, isAscending: true)
        
        switch result {
            case .success(let servers):
                return .success(servers.map({ $0.toModel() }))
            case .failure(let error): return .failure(error)
        } 
    }
}
