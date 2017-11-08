//
//  TSLServersListDataSource.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import CoreData
import UIKit

private let kServersListSortOption: String = "kServersListSortOption"

final class TSLServersListDataSource: ManagedObjectsDataSource<ServerData> {
	
	enum SortField: String {
		
		case name = "name"
		case distance = "distance"
		
	}
	
	var sortBy: SortField = .current {
		didSet {
			sortDescriptors = [
				NSSortDescriptor(key: sortBy.rawValue, ascending: true)
			]
			SortField.current = sortBy
		}
	}
	
	override func configure(tableView: UITableView) {
		
		sortBy = .current
		
		super.configure(tableView: tableView)
		
		tableView.register(cellType: TSLServerTableViewCell.self)
		
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let serverCell: TSLServerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		
		serverCell.configure(with: object(at: indexPath))
		
		return serverCell
		
	}
	
}

extension TSLServersListDataSource.SortField {
	
	static var all: [TSLServersListDataSource.SortField] = [.distance, .name]
	
	static fileprivate(set) var current: TSLServersListDataSource.SortField {
		// swiftlint:disable:previous strict_fileprivate
		get {
			let storedRawValue = UserDefaults.standard.string(forKey: kServersListSortOption) ?? ""
			return TSLServersListDataSource.SortField(rawValue: storedRawValue) ?? (all.first!)
			// swiftlint:disable:previous force_unwrapping
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: kServersListSortOption)
		}
	}
	
	var humanDescription: String {
		let localizedKey = "SORT.BY ".appending(self.rawValue.uppercased())
		return localizedKey.localized(using: "ServersList")
	}
	
}
