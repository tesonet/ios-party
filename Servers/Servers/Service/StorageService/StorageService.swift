//
//  StorageService.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation

class StorageService: StorageServiceProtocol {
    
    private var serverStorageManager: ServerStorageManager
    
    required init(serverStorageManager: ServerStorageManager) {
        self.serverStorageManager = serverStorageManager
    }
    
    func save(servers: [ServerModel], completion: @escaping ((Result<Bool, Error>) -> ())) {
        
        serverStorageManager.save(servers: servers, completion: completion)
    }
    
    func getServers(sortingMethod: SortingMethod) -> Result<[Server], Error> {
        let key = sortingMethod == .alphanumerical ? "name" : "distance"
        return serverStorageManager.getServers(sorting: key, isAscending: true)
    }
        
}
