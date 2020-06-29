//
//  Server+CoreDataProperties.swift
//  
//
//  Created by Ernestas Šeputis on 6/28/20.
//
//

import Foundation
import CoreData


extension Server {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: "Server")
    }

    @NSManaged public var distance: Int32
    @NSManaged public var name: String?

}
