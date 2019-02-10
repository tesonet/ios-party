//
//  ServerRespository.swift
//  Testio
//
//  Created by lbartkus on 10/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import RealmSwift

class ServerRespository {
    
    public enum ServerSorting: String {
        case name
        case distance
    }
    
    func fetchAll(sortedBy sortKey: ServerSorting = .name, ascending asc: Bool = true) -> [Server] {
        guard let realm = Realm.shared() else { return [] }
        let servers = realm.objects(Server.self).sorted(byKeyPath: sortKey.rawValue, ascending: asc)
        return servers.toArray()
    }
    
    func save(_ servers: [Server]) {
        guard let realm = Realm.shared() else { return }
        realm.addOrUpdateObjects(objects: servers)
    }
    
    func wipeUserData() {
        guard let realm = Realm.shared() else { return }
        let servers = fetchAll()
        realm.addOrUpdateObjects(objects: servers)
    }
}
