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

final class TSLUISessionManager {
	
	static let shared: TSLUISessionManager = TSLUISessionManager()
	
	private var loginObserver: NSObjectProtocol?
	private var logoutObserver: NSObjectProtocol?
	private var sessionExpiredObserver: NSObjectProtocol?
	
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
	
	private func getWindow() -> UIWindow {
		if let keyWindow = UIWindow.keyWindow {
			return keyWindow
		}
		if let keyWindow = self.window {
			return keyWindow
		}
		let newWindow = UIWindow(frame: UIScreen.main.bounds)
		newWindow.makeKeyAndVisible()
		self.window = newWindow
		return newWindow
	}
	
	final func showMainViewController() {
		
	}
	
	final func showLoginViewController() {
		getWindow().set(rootViewController: TSLLoginViewController.instantiate())
	}
	
	final func showSessionExpiredMessage() {
		
	}
	
}
