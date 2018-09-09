//
//  Server+CoreDataProperties.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//
//

import Foundation
import CoreData


extension Server {

    @nonobjc public class func serverFetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: "Server")
    }

    @NSManaged public var distance: Double
    @NSManaged public var name: String?

}
