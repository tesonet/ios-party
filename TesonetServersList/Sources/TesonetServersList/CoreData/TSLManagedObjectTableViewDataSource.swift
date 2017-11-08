//
//  TSLManagedObjectTableViewDataSource.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

/// Generic table view data source for managed object.
class ManagedObjectsDataSource<CoreDataObject: NSManagedObject>: NSObject,
	UITableViewDataSource,
	NSFetchedResultsControllerDelegate
{
	
	weak var tableView: UITableView? = .none {
		didSet(oldTableView) {
			
			oldTableView?.dataSource = .none
			
			if let tableView = tableView {
				configure(tableView: tableView)
			}
			
		}
	}
	
	private weak var managedObjectContext: NSManagedObjectContext!
	
	/// The sort descriptors of the fetch request.
	var sortDescriptors: [NSSortDescriptor] = [] {
		didSet {
			
			guard sortDescriptors != oldValue
				else {
					return
			}
			
			configureFetchedResultsController(force: true)
			
		}
	}
	
	/// The predicate of the fetch request.
	var predicate: NSPredicate? = .none {
		didSet {
			
			if
				predicate == nil
					&& oldValue == nil
			{
				return
			}
			
			guard
				let predicate = predicate,
				let oldValue = oldValue
				else {
					configureFetchedResultsController(force: true)
					return
			}
			
			guard predicate != oldValue
				else {
					return
			}
			
			configureFetchedResultsController(force: true)
			
		}
	}
	
	/// The fetch batch size of the fetch request.
	var fetchBatchSize: Int = 20 {
		didSet {
			configureFetchedResultsController(force: true)
		}
	}
	
	init(
		tableView: UITableView? = .none,
		managedObjectContext: NSManagedObjectContext = .coreMain)
	{
		self.tableView = tableView
		self.managedObjectContext = managedObjectContext
		super.init()
	}
	
	func configure(tableView: UITableView) {
		tableView.dataSource = self
	}
	
	/// Configures current fetched results controller, if there is any.
	///
	/// - Parameter force: Pass `true` to clean cache & force tableView to reload data,
	/// `false` - otherwise.
	private func configureFetchedResultsController(force: Bool = false) {
		guard _fetchedResultsController != nil
			else {
				return
		}
		
		configure(fetchedResultsController: fetchedResultsController,
							force: force)
		
	}
	
	/// Configures `fetchedResultsController`.
	///
	/// - Parameters:
	///   - fetchedResultsController: The `NSFetchedResultsController` to configure.
	///   - force: Pass `true` to clean cache & force tableView to reload data,
	/// `false` - otherwise.
	private func configure(
		fetchedResultsController: NSFetchedResultsController<CoreDataObject>,
		force: Bool = false)
	{
		
		if
			force,
			let cacheName = fetchedResultsController.cacheName
		{
			NSFetchedResultsController<CoreDataObject>.deleteCache(withName: cacheName)
		}
		
		configureFetchRequest(fetchedResultsController.fetchRequest)
		
		if force {
			
			do {
				try fetchedResultsController.performFetch()
			} catch {
				print(error)
			}
			
			tableView?.reloadData()
			
		}
		
	}
	
	/// Returns fetch request for `CoreDataObject`
	///
	/// - Returns: Fetch request for `CoreDataObject`.
	private func buildFetchRequest() -> NSFetchRequest<CoreDataObject> {
		
		let entityName: String
		if #available(iOS 10.0, *) {
			entityName = CoreDataObject.entity().name! // swiftlint:disable:this force_unwrapping
		} else {
			entityName = CoreDataObject.mr_entityName()
		}
		let fetchRequest: NSFetchRequest<CoreDataObject> = NSFetchRequest(entityName: entityName)
		
		configureFetchRequest(fetchRequest)
		
		return fetchRequest
		
	}
	
	/// Configures fetch request with sort descriptors, predicate & fetch batch size.
	///
	/// - Parameter fetchRequest: fetch request to configure.
	private func configureFetchRequest(_ fetchRequest: NSFetchRequest<CoreDataObject>) {
		
		fetchRequest.sortDescriptors = sortDescriptors
		
		fetchRequest.fetchBatchSize = fetchBatchSize
		
		fetchRequest.predicate = predicate
		
	}
	
	/// Returns Fetched results controller for `CoreDataObject`.
	///
	/// - Returns: Fetched results controller for `CoreDataObject`.
	private func buildFetchedResultsController() -> NSFetchedResultsController<CoreDataObject>{
		
		let fetchRequest = buildFetchRequest()
		
		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: managedObjectContext,
			sectionNameKeyPath: .none,
			cacheName: .none)
		
		fetchedResultsController.delegate = self
		
		return fetchedResultsController
		
	}
	
	private var _fetchedResultsController: NSFetchedResultsController<CoreDataObject>?
	var fetchedResultsController: NSFetchedResultsController<CoreDataObject> {
		if let _fetchedResultsController = _fetchedResultsController {
			return _fetchedResultsController
		}
		
		let fetchedResultsController = buildFetchedResultsController()
		configure(fetchedResultsController: fetchedResultsController, force: false)
		
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print(error)
		}
		
		_fetchedResultsController = fetchedResultsController
		
		return fetchedResultsController
		
	}
	
	// MARK: - NSFetchedResultsControllerDelegate
	
	func controllerWillChangeContent(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
		
		guard let tableView = tableView
			else {
				return
		}
		
		tableView.beginUpdates()
		
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange sectionInfo: NSFetchedResultsSectionInfo,
		atSectionIndex sectionIndex: Int,
		for type: NSFetchedResultsChangeType)
	{
		
		guard let tableView = tableView
			else {
				return
		}
		
		switch type {
			
		case .insert:
			
			tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
			
		case .delete:
			
			tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
			
		case .move,
				 .update:
			
			return
			
		}
		
	}
	
	func controller(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>,
		didChange anObject: Any,
		at indexPath: IndexPath?,
		for type: NSFetchedResultsChangeType,
		newIndexPath: IndexPath?)
	{
		
		guard let tableView = tableView
			else {
				return
		}
		
		// swiftlint:disable force_unwrapping
		
		switch type {
			
		case .move:
			
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		
		case .update:
			
			tableView.reloadRows(at: [indexPath!], with: .automatic)
			
		case .insert:
			
			tableView.insertRows(at: [newIndexPath!], with: .fade)
			
		case .delete:
			
			tableView.deleteRows(at: [indexPath!], with: .fade)
			
		}
		
		// swiftlint:enable force_unwrapping
		
	}
	
	func controllerDidChangeContent(
		_ controller: NSFetchedResultsController<NSFetchRequestResult>)
	{
		
		guard let tableView = tableView
			else {
				return
		}
		
		tableView.endUpdates()
		
	}
	
	// MARK: - UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}
	
	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int)
		-> Int
	{
		
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
		
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath)
		-> UITableViewCell
	{
		
		fatalError("You should override `func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)`")
		
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return .none
	}
	
	func object(at indexPath: IndexPath) -> CoreDataObject {
		return fetchedResultsController.object(at: indexPath)
	}
	
}
