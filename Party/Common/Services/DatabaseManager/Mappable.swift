//
//  Mappable.swift
//  Party
//
//  Created by Darius Janavicius on 18/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import CoreData

struct Attribute<T> {
    
    public var name: String
    
    public var value: T?
    
    public init(name: String, value: T?) {
        self.name = name
        self.value = value
    }
}

protocol Mappable {
    
    var managedObjectID: NSManagedObjectID? { get }
    
    init(managedObject: NSManagedObject)
    
    func attributes() -> [Attribute<Any>]
    
    // The name of the entity used in core data database.
    static func entityName() -> String
}
