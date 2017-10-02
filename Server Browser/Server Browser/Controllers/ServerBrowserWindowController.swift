//
//  ServerBrowserWindowController.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class ServerBrowserWindowController: NSWindowController, NSWindowDelegate,
                                    LoginViewControllerDelegate,
                                    ServerListViewControllerDelegate {
    private let tokenStorage: AccessTokenStorage
    private let serverListLoader: ServerListLoader
    
    private lazy var loginViewController: LoginViewController = {
        guard let viewController = LoginViewController(nibName: "LoginView",
                                                       bundle: nil) else {
            fatalError("Failed to initialize LoginViewController.")
        }
        viewController.delegate = self
        return viewController
    }()
    
    private lazy var loadScreenViewController: LoadScreenViewController = {
        guard let viewController = LoadScreenViewController(nibName: "LoadScreenView",
                                                            bundle: nil) else {
            fatalError("Failed to initialize LoadScreenViewController.")
        }
        return viewController
    }()
    
    private lazy var serverListViewController: ServerListViewController = {
        guard let viewController = ServerListViewController(nibName: "ServerListView",
                                                            bundle: nil) else {
            fatalError("Failed to initialize ServerListViewController.")
        }
        viewController.delegate = self
        return viewController
    }()
    
    init(serverListLoader: ServerListLoader, tokenStorage: AccessTokenStorage) {
        self.serverListLoader = serverListLoader
        self.tokenStorage = tokenStorage
        super.init(window: nil)
    }
    
    // MARK: - NSWindowController
    
    override var windowNibName: String! {
        return "ServerBrowserWindow"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    override func showWindow(_ sender: Any?) {
        guard !isWindowVisible else {
            return
        }
        
        // If there is stored token -> skip login screen
        if let storedToken = tokenStorage.storedToken {
            switchToViewController(loadScreenViewController)
            fetchServerList(withAccessToken: storedToken)
        }
        else {
            switchToViewController(loginViewController)
        }
        
        super.showWindow(sender)
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        serverListLoader.abortAllLoadingTasks()
    }
    
    // MARK: - LoginViewControllerDelegate
    
    func loginViewControllerDidRequestLogin(_ controller: LoginViewController) {
        guard controller == loginViewController else {
            return
        }
        
        switchToViewController(loadScreenViewController)
        requestAccessToken(forUser: controller.username,
                           password: controller.password)
    }
    
    // MARK: - ServerListViewControllerDelegate
    
    func serverListViewControllerDidRequestLogout(_ controller: ServerListViewController) {
        guard controller == serverListViewController else {
            return
        }
        
        tokenStorage.storedToken = nil
        clearCredentialsInLoginView()
        switchToViewController(loginViewController)
    }
    
    // MARK: - Private
    
    private var isWindowVisible: Bool {
        return isWindowLoaded ? window?.isVisible ?? false : false
    }
    
    private func switchToViewController(_ viewController: NSViewController) {
        window?.contentViewController = viewController
    }
    
    private func requestAccessToken(forUser username: String, password: String) {
        serverListLoader.requestAccessToken(forUser: username, password: password) {
            [weak self] (token, error) in
            if let token = token {
                self?.didReceiveAccessToken(token)
            }
            else {
                self?.didFailToGetAccessToken(withError: error)
            }
        }
    }
    
    private func fetchServerList(withAccessToken token: String) {
        serverListLoader.fetchServerList(withAccessToken: token) {
            [weak self] (serverList, error) in
            if let serverList = serverList {
                self?.didReceiveServerList(serverList)
            }
            else {
                self?.didFailToGetServerList(withError: error)
            }
        }
    }
    
    private func didReceiveAccessToken(_ token: String) {
        tokenStorage.storedToken = token
        fetchServerList(withAccessToken: token)
    }
    
    private func didFailToGetAccessToken(withError error: Error?) {
        DispatchQueue.main.async {
            [weak self] in
            self?.switchToViewController(self!.loginViewController)
            if error as? RequestError == .unauthorized {
                self?.showAuthorizationError()
            }
            else {
                self?.showGenericConnectionError()
            }
        }
    }
    
    private func didReceiveServerList(_ serverList: [Server]) {
        DispatchQueue.main.async {
            [weak self] in
            self?.serverListViewController.serverList = serverList
            self?.switchToViewController(self!.serverListViewController)
        }
    }
    
    private func didFailToGetServerList(withError error: Error?) {
        DispatchQueue.main.async {
            [weak self] in
            if error as? RequestError == .unauthorized {
                self?.tokenStorage.storedToken = nil
                self?.switchToViewController(self!.loginViewController)
            }
            else {
                self?.showFetchingFailedError()
            }
        }
    }
    
    private func clearCredentialsInLoginView() {
        loginViewController.username = ""
        loginViewController.password = ""
    }
    
    private func showAuthorizationError() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Authorization Error", comment: "Unauthorized Error alert title")
        alert.informativeText = NSLocalizedString("Please check your credentials and try again.", comment: "Unauthorized Error alert text")
        alert.beginSheetModal(for: window!)
    }
    
    private func showGenericConnectionError() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Connection Failed", comment: "Connection Failed alert title")
        alert.informativeText = NSLocalizedString("Could not connect to the server. Please try again later.", comment: "Connection Failed alert text")
        alert.beginSheetModal(for: window!)
    }
    
    private func showFetchingFailedError() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Fetching Failed", comment: "Fetching Failed alert title")
        alert.informativeText = NSLocalizedString("Could not fetch data from the server.", comment: "Fetching Failed alert text")
        alert.addButton(withTitle: "Retry")
        alert.addButton(withTitle: "Log out")
        alert.beginSheetModal(for: window!) { (modalResponse) in
            if modalResponse == NSAlertFirstButtonReturn {
                self.fetchServerList(withAccessToken: self.tokenStorage.storedToken!)
            }
            else {
                self.tokenStorage.storedToken = nil
                self.switchToViewController(self.loginViewController)
            }
        }
    }
}
