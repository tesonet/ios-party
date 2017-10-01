//
//  ServerBrowserWindowController.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class ServerBrowserWindowController: NSWindowController, LoginViewControllerDelegate,
                                    ServerListViewControllerDelegate {
    // MARK: - Outlets
    
    // ...
    
    // MARK: -
    
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
    
    init() {
        super.init(window: nil)
    }
    
    // MARK: - NSWindowController
    
    override var windowNibName: String! {
        return "ServerBrowserWindow"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // ...
        switchToViewController(loginViewController)
    }
    
    // MARK: - LoginViewControllerDelegate
    
    func loginViewControllerDidRequestLogin(_ controller: LoginViewController) {
        // ...
    }
    
    // MARK: - ServerListViewControllerDelegate
    
    func serverListViewControllerDidRequestLogout(_ controller: ServerListViewController) {
        // ...
    }
    
    // MARK: - Private
    
    func switchToViewController(_ viewController: NSViewController) {
        window?.contentViewController = viewController
    }
}
