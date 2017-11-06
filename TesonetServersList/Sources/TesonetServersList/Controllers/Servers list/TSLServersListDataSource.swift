//
//  TSLServersListDataSource.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import UIKit

final class TSLServersListDataSource: ManagedObjectsDataSource<ServerData> {
	
	override func configure(tableView: UITableView) {
		super.configure(tableView: tableView)
		
		tableView.register(cellType: TSLServerTableViewCell.self)
		
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let serverCell: TSLServerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		
		serverCell.configure(with: object(at: indexPath))
		
		return serverCell
		
	}
	
}
