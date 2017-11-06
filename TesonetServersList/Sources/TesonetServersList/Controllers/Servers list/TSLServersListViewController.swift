//
//  TSLServersListViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

final class TSLServersListViewController: TSLBaseViewController,
	StoryboardBased,
	UITableViewDelegate
{
	
	@IBOutlet private weak var tableView: UITableView!
	
	private let serversListModule: ServersListModule = ServersListModule()
	
	private var dataSource: UITableViewDataSource!
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(cellType: TSLServerTableViewCell.self)
		tableView.register(headerFooterViewType: TSLServersListSectionHeaderView.self)
		
		configureNavigationBarButtons()
		
		configureTableView()
		
		loadData()
		
	}
	
	private func configureNavigationBarButtons() {
		let logoImage: UIImage? = UIImage.logoDark
			.scaled(changingHeightTo: 22.0)?
			.withRenderingMode(.alwaysOriginal)
		let leftButton = UIBarButtonItem(image: logoImage,
																		 style: .plain,
																		 target: .none,
																		 action: .none)
		leftButton.isEnabled = false
		navigationItem.leftBarButtonItem = leftButton
		
		let logoutImage: UIImage? = UIImage.logoutIcon
			.scaled(changingHeightTo: 22.0)?
			.withRenderingMode(.alwaysOriginal)
		let logoutButton = UIBarButtonItem(image: logoutImage,
																		 style: .plain,
																		 target: self,
																		 action: #selector(logoutButtonPressed(_:)))
		navigationItem.rightBarButtonItem = logoutButton
		
	}
	
	@objc
	private func logoutButtonPressed(_ sender: UIBarButtonItem) {
		TSLUserSessionManager.shared.logout()
	}
	
	private func configureTableView() {
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionHeaderHeight = 20.0
		
		tableView.delegate = self
		
		let dataSource: TSLServersListDataSource = TSLServersListDataSource()
		dataSource.tableView = tableView
		self.dataSource = dataSource
		
	}
	
	func loadData() {
		
		serversListModule.getServersList { [weak self] (result) in
			
			guard result.isSuccess
				else {
					self?.showError(result.error!) // swiftlint:disable:this force_unwrapping
					return
			}
			
		}
		
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let sectionHeader: TSLServersListSectionHeaderView? = tableView.dequeueReusableHeaderFooterView()
		
		return sectionHeader
		
	}
	
}
