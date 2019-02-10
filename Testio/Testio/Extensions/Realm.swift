//
//  Realm.swift
//  Testio
//
//  Created by lbartkus on 10/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    class func shared() -> Realm? {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            
        })
        Realm.Configuration.defaultConfiguration = config
        return try? Realm()
    }
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
    
    func addOrUpdateObj(obj: Object) {
        do {
            try self.safeWrite {
                self.add(obj, update: true)
            }
        } catch {
            print("Realm Manager Error")
        }
    }
    
    func addOrUpdateObjects(objects: [Object]) {
        do {
            try self.safeWrite {
                for obj in objects {
                    self.add(obj, update: true)
                }
            }
        } catch {
            print("Realm Manager Error")
        }
    }
    
    func deleteObjects(objects: [Object]) {
        do {
            try self.safeWrite {
                for obj in objects {
                    self.delete(obj)
                }
            }
        } catch {
            print("Realm Manager Error")
        }
    }
}
