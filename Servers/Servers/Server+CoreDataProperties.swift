//
//  Server+CoreDataProperties.swift
//  
//
//  Created by Rimantas Lukosevicius on 11/06/2018.
//
//

import Foundation
import CoreData


extension Server {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: "Server")
    }

    @NSManaged public var name: String?
    @NSManaged public var distance: Double

}
