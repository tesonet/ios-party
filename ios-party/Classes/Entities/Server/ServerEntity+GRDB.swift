//
//  ServerEntity+GRDB.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import GRDB

extension ServerEntity: TableRecord, FetchableRecord, PersistableRecord {
    // MARK: - TableRecord
    static var databaseTableName = "servers"
    
    // MARK: - PersistableRecord
    func encode(to container: inout PersistenceContainer) {
        container["name"] = name
        container["distance"] = distance
    }
}
