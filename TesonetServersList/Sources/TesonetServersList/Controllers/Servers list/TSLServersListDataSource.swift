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
		
		static var current: SortField {
			let storedRawValue = UserDefaults.standard.string(forKey: kServersListSortOption) ?? ""
			return SortField(rawValue: storedRawValue) ?? .name
		}
		
	}
	
	var sortBy: SortField = .current {
		didSet {
			sortDescriptors = [
				NSSortDescriptor(key: sortBy.rawValue, ascending: true)
			]
			UserDefaults.standard.set(sortBy.rawValue, forKey: kServersListSortOption)
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
