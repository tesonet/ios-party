//
//  RealmPersistentStorage.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmPersistentStorage{
    
    static func updateServerList(list : [Server]){
        let realm = try! Realm()
        
        do{
            try realm.write{
                realm.delete(getServerList())
                realm.add(list)
            }
        }catch{
            print("Could not write to realm database")
        }
    }
    
    static func getServerList() -> Results<Server>{
        let realm = try! Realm()
        
        let serverList = realm.objects(Server.self)
        return serverList.sorted(byKeyPath: "name", ascending: true)
    }
    
    static func deleteServerList(){
        let realm = try! Realm()
        
        do{
            try realm.write {
                realm.delete(getServerList())
            }
        }catch{
            print("Could not delete server list")
        }
    }
    
}
