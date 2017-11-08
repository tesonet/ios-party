//
//  TSLServersListViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

private let floatingViewAnimationDuration: TimeInterval = 1.25

final class TSLServersListViewController: TSLBaseViewController,
	StoryboardBased,
	UITableViewDelegate
{
	
	@IBOutlet private weak var tableView: UITableView!
	
	private var dataSource: TSLServersListDataSource!
	
	private weak var refreshControl: UIRefreshControl!
	
	private let serversListModule: ServersListModuleProtocol = ServersListModule()
	
	@IBOutlet private weak var sortFloatingView: TSLServersListSortFloatingView!
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	private let searchController: UISearchController = UISearchController(searchResultsController: .none)
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		configure()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		configureFloatingViewPosition(animated: false)
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

// MARK: - TSLServersListSortFloatingViewDelegate

extension TSLServersListViewController: TSLServersListSortFloatingViewDelegate {
	
	func tslServersListSortFloatingView(
		_ view: TSLServersListSortFloatingView,
		didSelect sortField: TSLServersListDataSource.SortField)
	{
		dataSource.sortBy = sortField
		configureFloatingViewPosition(animated: false, force: true)
	}
	
}

// MARK: - UIScrollViewDelegate

extension TSLServersListViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		configureFloatingViewPosition(animated: true)
		
	}
	
	// MARK: Floating view config
	
	private func configureFloatingViewPosition(animated: Bool, force: Bool = false) {
		
		guard !searchController.isActive
			else {
				if !sortFloatingView.isHidden { // hide floating view
					sortFloatingView.isHidden = true
				}
				return
		}
		
		let floatingViewHeight: CGFloat = sortFloatingView.frame.height
		
		let viewHeight = min(
			floatingViewHeight - max(tableView.contentOffset.y, 0),
			floatingViewHeight)
		
		// origin.y, because using conatraint & animating with layoutIfNeeded leads to animation of
		// table view section header view.
		let floatingViewNewOriginY = min(self.view.frame.height - viewHeight, self.view.frame.height)
		
		guard sortFloatingView.frame.origin.y != floatingViewNewOriginY || force
			else {
				return
		}
		
		// show sortFloatingView before animation begins
		if viewHeight > 0 && sortFloatingView.isHidden {
			sortFloatingView.isHidden = false
		}
		
		animateFloatingView(
			animated: animated,
			animationBlock: { [unowned self] in
				
				self.sortFloatingView.frame.origin.y = floatingViewNewOriginY
				if viewHeight > 0.0 {
					self.sortFloatingView.alpha = 1.0 * (viewHeight / floatingViewHeight)
				} else {
					self.sortFloatingView.alpha = 0.0
				}
				
			},
			animationCompletionBlock: { [unowned self] (_) in
				
				// Hide sort floating view
				if viewHeight <= 0 && !self.sortFloatingView.isHidden {
					self.sortFloatingView.isHidden = true
				}
				
				// Fix table view bottom content inset to make bottom cells visible and not
				// overlapped by sort floating view.
				let tableViewBottomInset: CGFloat =
					(viewHeight > 0) || (self.tableView.contentOffset.y <= floatingViewHeight * 2)
					? floatingViewHeight
					: 0.0
				if self.tableView.contentInset.bottom != tableViewBottomInset {
					self.tableView.contentInset.bottom = tableViewBottomInset
					self.tableView.scrollIndicatorInsets.bottom = tableViewBottomInset
				}
				
		})
		
	}
	
	private func animateFloatingView(
		animated: Bool,
		animationBlock: @escaping () -> Void,
		animationCompletionBlock: @escaping (Bool) -> Void)
	{
		
		guard animated
			else {
				animationBlock()
				animationCompletionBlock(true)
				return
		}
		
		UIView.animate(
			withDuration: floatingViewAnimationDuration,
			delay: 0.0,
			usingSpringWithDamping: 0.2,
			initialSpringVelocity: 1.5,
			options: [.curveEaseInOut, .beginFromCurrentState],
			animations: animationBlock,
			completion: animationCompletionBlock)
		
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
	
	func didPresentSearchController(_ searchController: UISearchController) {
		
		if #available(iOS 10.0, *) {
			tableView.refreshControl = .none
		}
		refreshControl?.removeFromSuperview()
		refreshControl?.removeTarget(self,
																 action: #selector(refreshControlDidPullToRefersh(_:)),
																 for: .valueChanged)
		
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
		
		configureRefreshControl()
		
		DispatchQueue.main.async { [unowned self] in
			self.configureFloatingViewPosition(animated: true, force: true)
		}
		
	}
	
}

// MARK: - Configurations

extension TSLServersListViewController {
	
	private func configure() {
		
		configureSearchController()
		
		configureNavigationBarButtons()
		
		configureTableView()
		
		configureSortFloatingView()
		
	}
	
	private func configureSortFloatingView() {
		sortFloatingView.delegate = self
		sortFloatingView.translatesAutoresizingMaskIntoConstraints = false
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
	
}
