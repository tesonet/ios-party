//
//  DataManager.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

protocol SyncProtocol {
    func syncFinished()
}

private let dataManager = DataManager()

class DataManager : NSObject {
    class var sharedInstance : DataManager {
        return dataManager
    }
    
    var delegate : SyncProtocol?
    
    func sync(servers : [Server]) {
        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm()
            realm.beginWrite()
            
            let ids = servers.map { $0.name }
            let objectsToDelete = realm.objects(Server.self).filter("NOT (name IN %@)", ids)
            if !objectsToDelete.isEmpty {
                realm.delete(objectsToDelete)
            }
            
            for server in servers {
                if realm.object(ofType: Server.self, forPrimaryKey: server.name) != nil {
                    realm.add(server, update: true)
                } else {
                    realm.add(server)
                }
            }
            
            try! realm.commitWrite()
            
            DispatchQueue.main.async {
                self.delegate!.syncFinished()
            }
        }
    }
    
    
}

extension Results {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}
