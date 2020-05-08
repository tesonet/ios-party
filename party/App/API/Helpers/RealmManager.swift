//
//  RealmManager.swift
//  party
//
//  Created by Paulius on 08/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import RealmSwift

final class RealmManager {
    
    class func save(_ servers: [Server]) {
        if let realm = try? Realm() {
            do {
                try realm.write {
                    realm.add(servers)
                }
            } catch {
               print(error)
           }
        }
    }
    
    class func getServers() -> [Server] {
        if let realm = try? Realm() {
            return Array(realm.objects(Server.self))
        }
        return []
    }
}
