//
//  StorageServiceProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation

protocol StorageServiceProtocol: class {
        
    init(serverStorageManager: ServerStorageManager)
    
    func save(servers: [ServerModel], completion: @escaping ((Result<Bool, Error>) -> ()))
    func getServers(sortingMethod: SortingMethod) -> Result<[ServerModel], Error>
}
