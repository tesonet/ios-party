//
//  CoreDataStack.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import CoreData

/// Core data stack.
internal struct CoreDataStack {
	
	/// Default Core data stack.
	static let core: CoreDataStack = {
		let modelName = "TesonetServersList"
		guard let stack = CoreDataStack(modelName: modelName,
																		protectionType: .complete)
			else {
				fatalError("Couldn't initialize CoreDataStack with model name: \(modelName)")
		}
		return stack
	}()
	
	/// CoreData model name.
	let modelName: String
	
	/// DB location URL.
	let storeURL: URL
	
	/// `NSManagedObjectModel`.
	let model: NSManagedObjectModel
	
	/// `NSPersistentStoreCoordinator`.
	let storeCoordinator: NSPersistentStoreCoordinator
	
	/// `NSPersistentStore`.
	let persistentStore: NSPersistentStore
	
	/// Root saving context.
	private let rootContext: NSManagedObjectContext
	
	/// Managed object context for saving operations.
	let savingContext: NSManagedObjectContext
	
	/// Managed object context for main queue.
	let mainContext: NSManagedObjectContext
	
	init?( //swiftlint:disable:this function_body_length
		modelName: String,
		in bundle: Bundle = .main,
		protectionType: FileProtectionType = .completeUntilFirstUserAuthentication)
	{
		
		let momdExtension = "momd"
		let momdExtensionWithDot = ".".appending(momdExtension)
		var modelName = modelName
		if
			modelName.hasSuffix(momdExtensionWithDot),
			let range = modelName.range(of: momdExtensionWithDot)
		{
			modelName.replaceSubrange(range, with: "")
		}
		
		guard
			let modelURL = bundle.url(forResource: modelName, withExtension: "momd")
			else {
				return nil
		}
		
		guard let model = NSManagedObjectModel(contentsOf: modelURL)
			else {
				return nil
		}
		
		let storeURL: URL = FileManager.default
			.applicationSupportDirectory
			.appendingPathComponent(modelName, isDirectory: true)
			.appendingPathComponent(modelName, isDirectory: false)
			.appendingPathExtension("sqlite")
		
		do {
			let storeDirectoryURL: URL = storeURL.deletingLastPathComponent()
			
			let directororyAttributes: [FileAttributeKey : Any] =
				[.protectionKey : protectionType]
			
			if !FileManager.default.fileExists(atPath: storeDirectoryURL.path) {
				try FileManager.default.createDirectory(at: storeDirectoryURL,
																								withIntermediateDirectories: true,
																								attributes: directororyAttributes)
			}
		} catch {
			print(error)
			return nil
		}
		
		let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		
		let sqliteOptions: [AnyHashable : Any] = ["journal_mode" : "WAL"]
		
		let options: [AnyHashable : Any] =
			[NSMigratePersistentStoresAutomaticallyOption : NSNumber(value: true),
			 NSInferMappingModelAutomaticallyOption : NSNumber(value: true),
			 NSSQLitePragmasOption: sqliteOptions,
			 NSPersistentStoreFileProtectionKey: protectionType]
		
		let persistentStore: NSPersistentStore
		do {
			
			persistentStore = try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
																																configurationName: .none,
																																at: storeURL,
																																options: options)
			
		} catch {
			
			print(error)
			
			return nil
			
		}
		
		let rootContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		rootContext.persistentStoreCoordinator = storeCoordinator
		
		rootContext.performAndWait {
			
			rootContext.obtainPermanentIDsBeforeSaving()
			rootContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
			rootContext.mr_setWorkingName(modelName.appending(" Root Saving Context"))
			
			rootContext.undoManager = .none
			
		}
		
		let savingContext = rootContext.child(concurrencyType: .privateQueueConcurrencyType,
																					mergesChangesFromParent: true)
		
		savingContext.performAndWait {
			
			savingContext.mr_setWorkingName(modelName.appending(" Saving Context"))
			
		}
		
		let mainContext = rootContext.child(concurrencyType: .mainQueueConcurrencyType,
																				mergesChangesFromParent: true)
		
		mainContext.performAndWait {
			
			mainContext.mr_setWorkingName(modelName.appending(" Default Context"))
			
		}
		
		self.modelName = modelName
		self.storeURL = storeURL
		self.model = model
		self.storeCoordinator = storeCoordinator
		self.persistentStore = persistentStore
		self.rootContext = rootContext
		self.mainContext = mainContext
		self.savingContext = savingContext
		
	}
	
}
