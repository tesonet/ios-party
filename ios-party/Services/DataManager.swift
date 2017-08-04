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
    
    func sync(cars : [Server]) {
        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm()
            realm.beginWrite()
            
            let ids = cars.map { $0.id }
            let objectsToDelete = realm.objects(Server.self).filter("NOT (id IN %@)", ids)
            if !objectsToDelete.isEmpty {
                realm.delete(objectsToDelete)
            }
            
            for car in cars {
                if realm.object(ofType: Server.self, forPrimaryKey: car.id) != nil {
                    realm.add(car, update: true)
                } else {
                    realm.add(car)
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
