//
//  ServersRepository.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import RealmSwift
import PromiseKit

class ServersRepository {
    fileprivate let serviceManager = ServersServiceManager()
    
    func updateServersList() -> Promise<Void> {
        return serviceManager.getServersList().then { servers -> Promise<Void> in
            guard let servers = servers else {
                return .value(())
            }
            
            guard let realm = try? Realm() else {
                return .value(())
            }
            
            try? realm.write {
                realm.delete(realm.objects(ServerModel.self))
                realm.add(servers)
            }
            
            return .value(())
        }
    }
    
    func getAllServers(sortBy: String?) -> Results<ServerModel>? {
        guard let realm = try? Realm() else {
            return nil
        }
        
        let servers = realm.objects(ServerModel.self)
        guard let sortBy = sortBy else {
            return servers
        }
        
        return servers.sorted(byKeyPath: sortBy)
    }
}
