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
	private weak var refreshControl: UIRefreshControl!
	
	private let serversListModule: ServersListModuleProtocol = ServersListModule()
	
	private var dataSource: TSLServersListDataSource!
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	private let searchController: UISearchController = UISearchController(searchResultsController: .none)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureSearchController()
		
		configureNavigationBarButtons()
		
		configureTableView()
		
	}
	
	private func configureSearchController() {
		self.definesPresentationContext = true
		searchController.searchResultsUpdater = self
		searchController.delegate = self
		
		searchController.dimsBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = true
		
		searchController.searchBar.sizeToFit()
		searchController.searchBar.barTintColor = .navigationBarBackground
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.isTranslucent = false
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
		} else {
			tableView.tableHeaderView = searchController.searchBar
			tableView.contentOffset = CGPoint(x: 0.0, y: searchController.searchBar.frame.height)
		}
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
	
	private func configureTableView() {
		
		tableView.register(headerFooterViewType: TSLServersListSectionHeaderView.self)
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionHeaderHeight = 20.0
		
		tableView.delegate = self
		
		let dataSource: TSLServersListDataSource = TSLServersListDataSource()
		dataSource.tableView = tableView
		self.dataSource = dataSource
		
		configureRefreshControl()
		
	}
	
	private func configureRefreshControl() {
		let refreshControl: UIRefreshControl = UIRefreshControl()
		refreshControl.addTarget(self,
														 action: #selector(refreshControlDidPullToRefersh(_:)),
														 for: .valueChanged)
		if #available(iOS 10.0, *) {
			tableView.refreshControl = refreshControl
		} else {
			tableView.insertSubview(refreshControl, at: 0)
		}
		self.refreshControl = refreshControl
	}
	
	// MARK: - Load data
	
	func loadData(completion: (() -> Void)? = .none) {
		
		serversListModule.getServersList { [weak self] (result) in
			
			completion?()
			self?.refreshControl?.endRefreshing()
			
			guard result.isSuccess
				else {
					DispatchQueue.main.async {
						self?.showError(result.error!) // swiftlint:disable:this force_unwrapping
					}
					return
			}
			
		}
		
	}
	
	// MARK: - Actions
	
	@objc
	private func refreshControlDidPullToRefersh(_ sender: UIRefreshControl) {
		loadData()
	}
	
	@objc
	private func logoutButtonPressed(_ sender: UIBarButtonItem) {
		TSLUserSessionManager.shared.logout()
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let sectionHeader: TSLServersListSectionHeaderView? = tableView.dequeueReusableHeaderFooterView()
		
		return sectionHeader
		
	}
	
	// MARK: - Keyboard
	
	override func handleKeyboardParameters(_ parameters: TSLBaseViewController.KeyboardAppearanceParameters)
	{
		
		let contentInset = UIEdgeInsets(top: 0.0,
																		left: 0.0,
																		bottom: parameters.keyboardHeight,
																		right: 0.0)
		
		tableView.contentInset = contentInset
		tableView.scrollIndicatorInsets = contentInset
		
	}
	
}

// MARK: - UISearchResultsUpdating

extension TSLServersListViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard
			searchController.isActive,
			let seasrchString = searchController.searchBar.text,
			!seasrchString.isEmpty
			else {
				self.dataSource.predicate = .none
				return
		}
		let searchText = "*".appending(seasrchString.normalized()).appending("*")
		self.dataSource.predicate = NSPredicate(format: "searchString LIKE %@", searchText)
	}
	
}

// MARK: - UISearchControllerDelegate

extension TSLServersListViewController: UISearchControllerDelegate {
	
	func willPresentSearchController(_ searchController: UISearchController) {
		if #available(iOS 10.0, *) {
			tableView.refreshControl = .none
		}
		refreshControl?.removeFromSuperview()
		refreshControl?.removeTarget(self,
																 action: #selector(refreshControlDidPullToRefersh(_:)),
																 for: .valueChanged)
	}
	
	func willDismissSearchController(_ searchController: UISearchController) {
		configureRefreshControl()
	}
	
}
