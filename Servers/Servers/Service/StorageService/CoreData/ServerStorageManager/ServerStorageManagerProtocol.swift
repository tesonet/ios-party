//
//  ServerStorageManagerProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation
import CoreData

protocol ServerStorageManagerProtocol {
    init(coreDataManager: CoreDataManager)
    
    func save(servers: [ServerModel], completion: @escaping ((Result<Bool, Error>) -> ()))
    func getServers(sorting: String, isAscending: Bool) -> Result<[Server], Error>
}
