//
//  TSLUISessionManager.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import UIKit
import Reusable

/// Handles UI updates.
final class TSLUISessionManager {
	
	static let shared: TSLUISessionManager = TSLUISessionManager()
	
	private var loginObserver: NSObjectProtocol?
	private var logoutObserver: NSObjectProtocol?
	private var sessionExpiredObserver: NSObjectProtocol?
	
	/// Strong reference to key window.
	private var window: UIWindow?

	// MARK: - Lifecycle
	
	private init() {
		
		logoutObserver = NotificationCenter.default.addObserver(forName: .tslLogin,
																														object: .none,
																														queue: .main)
		{ [unowned self] (_) in
			self.showMainViewController()
		}
		
		logoutObserver = NotificationCenter.default.addObserver(forName: .tslLogout,
																														object: .none,
																														queue: .main)
		{ [unowned self] (_) in
			self.showLoginViewController()
		}
		
		sessionExpiredObserver = NotificationCenter.default.addObserver(forName: .tslSessionExpired,
																																		object: .none,
																																		queue: .main)
		{ [unowned self] (_) in
			self.showSessionExpiredMessage()
		}
		
	}
	
	deinit {
		
		if let loginObserver = loginObserver {
			NotificationCenter.default.removeObserver(loginObserver,
																								name: .tslLogin,
																								object: .none)
			self.loginObserver = .none
		}
		
		if let logoutObserver = logoutObserver {
			NotificationCenter.default.removeObserver(logoutObserver,
																								name: .tslLogout,
																								object: .none)
			self.logoutObserver = .none
		}
		
		if let sessionExpiredObserver = sessionExpiredObserver {
			NotificationCenter.default.removeObserver(sessionExpiredObserver,
																								name: .tslSessionExpired,
																								object: .none)
			self.sessionExpiredObserver = .none
		}
		
	}
	
	// MARK: - Notifications handlers
	
	/// Returns key window. If no key window exists - creates a new one.
	///
	/// - Returns: key window.
	private func getWindow() -> UIWindow {
		if let keyWindow = UIWindow.keyWindow {
			return keyWindow
		}
		if let keyWindow = self.window {
			return keyWindow
		}
		
		let newWindow = UIWindow(frame: UIScreen.main.bounds)
		newWindow.windowLevel = UIWindowLevelStatusBar + 1
		newWindow.makeKeyAndVisible()
		self.window = newWindow
		return newWindow
	}
	
	final func showMainViewController() {
		
		let serversListVC: TSLServersListViewController = .instantiate()
		
		let mainViewController = UINavigationController(rootViewController: serversListVC)
		mainViewController.navigationBar.isTranslucent = false
		mainViewController.navigationBar.barTintColor = .navigationBarBackground
		mainViewController.navigationBar.shadowImage = UIImage()
		
		getWindow().set(rootViewController: mainViewController)
		
		let loadingVC: LoadingViewController = .instantiate()
		serversListVC.present(loadingVC,
													animated: false,
													completion: .none)
		loadingVC.loadDescriptor = "LOADER.TEXT".localized(using: "ServersList")
		serversListVC.loadData { [weak loadingVC] in
			loadingVC?.performSegue(withIdentifier: "unwind", sender: .none)
		}
		
	}
	
	final func showLoginViewController() {
		getWindow().set(rootViewController: TSLLoginViewController.instantiate())
	}
	
	final func showSessionExpiredMessage() {
		
		guard let viewController = UIWindow.visibleViewController() as? TSLBaseViewController
			else {
				return
		}
		
		viewController.showError(APIError.sessionExpired) {
			TSLUserSessionManager.shared.logout()
		}
		
	}
	
}
