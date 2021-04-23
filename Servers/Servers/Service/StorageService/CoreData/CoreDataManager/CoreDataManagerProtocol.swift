//
//  CoreDataManagerProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation

import CoreData

protocol CoreDataManagerProtocol {
    var mainContext: NSManagedObjectContext { get }
    var newBackgroundContext: NSManagedObjectContext { get }
    
    func createItem<T: NSManagedObject>(from dic: [String: Any], in context: NSManagedObjectContext) -> T
    func fetch<T: NSManagedObject>(sortDesctiptors: [NSSortDescriptor], predicate: NSPredicate?, in context: NSManagedObjectContext) -> Result<[T], Error>
    func save(context: NSManagedObjectContext) -> Result<Bool, Error>
    func delete(item: NSManagedObject, in context: NSManagedObjectContext)
}
