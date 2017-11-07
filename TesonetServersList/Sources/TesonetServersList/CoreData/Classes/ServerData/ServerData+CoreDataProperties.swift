//
//  ServerData+CoreDataProperties.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//
//

import Foundation
import CoreData

extension ServerData {
	
	@nonobjc
	class func fetchRequest() -> NSFetchRequest<ServerData> {
		return NSFetchRequest<ServerData>(entityName: "ServerData")
	}
	
	@NSManaged var distance: Double
	
	@objc dynamic var name: String? {
		get {
			willAccessValue(forKey: #function)
			let result = primitiveValue(forKey: #function) as? String
			didAccessValue(forKey: #function)
			return result
		}
		set {
			willChangeValue(forKey: #function)
			setPrimitiveValue(newValue, forKey: #function)
			didChangeValue(forKey: #function)
			
			let searchString = newValue?.normalized()
			
			if self.searchString != searchString {
				self.searchString = searchString
			}
		}
	}
	
	@NSManaged var searchString: String?
	
}
