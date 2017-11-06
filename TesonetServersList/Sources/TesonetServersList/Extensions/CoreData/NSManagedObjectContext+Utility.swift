//
//  NSManagedObjectContext+Utility.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord
import enum Alamofire.Result

extension NSManagedObjectContext {
	
	// MARK: - Contexts
	
	static var coreSaving: NSManagedObjectContext {
		return CoreDataStack.core.savingContext
	}
	
	static var coreMain: NSManagedObjectContext {
		return CoreDataStack.core.mainContext
	}
	
	final func child(
		concurrencyType: NSManagedObjectContextConcurrencyType = .privateQueueConcurrencyType,
		mergesChangesFromParent: Bool = false)
		-> NSManagedObjectContext
	{
		let newContext = NSManagedObjectContext(concurrencyType: concurrencyType)
		
		newContext.parent = self
		
		newContext.undoManager = .none
		
		newContext.setup(mergesChangesFromParent: mergesChangesFromParent)
		
		return newContext
		
	}
	
	// MARK: - On save notifications
	
	private func setup(mergesChangesFromParent: Bool = false) {
		
		defer {
			obtainPermanentIDsBeforeSaving()
		}
		
		guard
			mergesChangesFromParent,
			let rootContext = parent
			else {
				return
		}
		
		if #available(iOS 10.0, *) {
			self.automaticallyMergesChangesFromParent = mergesChangesFromParent
			return
		}
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(rootContextDidSave(notification:)),
																					 name: .NSManagedObjectContextDidSave,
																					 object: rootContext)
		
	}
	
	// MARK: - Permanent IDs
	
	final func obtainPermanentIDsBeforeSaving() {
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(contextWillSave(notification:)),
																					 name: .NSManagedObjectContextWillSave,
																					 object: self)
		
	}
	
	// MARK: - On save notifications
	
	@objc
	private func contextWillSave(notification: Notification) {
		
		guard let context = notification.object as? NSManagedObjectContext
			else {
				return
		}
		
		guard !context.insertedObjects.isEmpty
			else {
				return
		}
		
		let insertedObjects = context.insertedObjects.filter { $0.objectID.isTemporaryID }
		
		guard !insertedObjects.isEmpty
			else {
				return
		}
		
		try? context.obtainPermanentIDs(for: Array(insertedObjects))
		
	}
	
	@objc
	private func rootContextDidSave(notification: Notification) {
		
		guard
			let context = notification.object as? NSManagedObjectContext,
			context == parent
			else {
				return
		}
		
		if #available(iOS 10.0, *) {
			return
		}
		
		DispatchQueue.main.async { [weak self] in
			
			guard let sSelf = self
				else {
					return
			}
			
			// The objects can't be a fault.
			if let objects = notification.userInfo?[NSUpdatedObjectsKey] as? [NSManagedObject] {
				objects.forEach {
					sSelf.object(with: $0.objectID).willAccessValue(forKey: .none)
				}
			}
			
			sSelf.mergeChanges(fromContextDidSave: notification)
			
		}
		
	}
	
}

extension NSManagedObjectContext {
	
	class SavePromise {
		
		typealias SavingBlock = (_ localContext: NSManagedObjectContext) -> Void
		private typealias RawResultingBlock = (_ thereWasChanges: Bool, _ error: Error?) -> Void
		typealias ResultingBlock = (Result<Bool>) -> Void
		
		private let context: NSManagedObjectContext
		
		private var isSavingBlockSet: Bool = false {
			didSet {
				execute()
			}
		}
		private var savingBlock: SavingBlock? {
			didSet {
				isSavingBlockSet = savingBlock != nil
			}
		}
		
		private var isCompletionBlockSet: Bool = false {
			didSet {
				execute()
			}
		}
		private var completionBlock: RawResultingBlock? {
			didSet {
				isCompletionBlockSet = completionBlock != nil
			}
		}
		
		init(context: NSManagedObjectContext) {
			self.context = context
		}
		
		func with(_ savingBlock: @escaping SavingBlock) -> SavePromise {
			self.savingBlock = { (localContext) in
				savingBlock(localContext)
				self.savingBlock = .none
			}
			return self
		}
		
		func then(_ completionBlock: @escaping ResultingBlock) {
			self.completionBlock = { (thereWasChanges, error) in
				let result: Result<Bool>
				if let error = error {
					result = .failure(error)
				} else {
					result = .success(thereWasChanges)
				}
				completionBlock(result)
				self.completionBlock = .none
			}
		}
		
		func now() {
			then { (result) in
				if let error = result.error {
					print(String(describing: error))
				}
			}
		}
		
		private var isExecuted: Bool = false
		
		private func execute() {
			guard isSavingBlockSet && isCompletionBlockSet && !isExecuted
				else {
					return
			}
			isExecuted = true
			// swiftlint:disable:next force_unwrapping
			context.mr_save(savingBlock!, completion: completionBlock!)
		}
	}
	
	func saveData(_ block: @escaping NSManagedObjectContext.SavePromise.SavingBlock) -> SavePromise {
		let promise = SavePromise(context: self)
		return promise.with(block)
	}
	
}
