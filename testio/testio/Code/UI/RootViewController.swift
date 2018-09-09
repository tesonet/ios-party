//
//  RootViewController.swift
//  testio
//
//  Created by Tesonet on 09/09/2018.
//  Copyright © 2018 Tesonet. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class RootViewController: UIViewController, LoginViewControllerDelegate, ServersListViewControllerDelegate {
    private lazy var loginViewControler: LoginViewController = {
        let viewController = LoginViewController(loginManager: self.userLoginManager)
        
        viewController.delegate = self
        
        return viewController
    }()
    
    private lazy var progressViewController: ProgressViewController = {
        let viewController = ProgressViewController()
        return viewController
    }()
    
    private lazy var serversNavigationController: UINavigationController = {
        let viewController = ServersListViewController(persistenceStore: self.persistenceStore)
        
        viewController.delegate = self
    
        return UINavigationController(rootViewController: viewController)
    }()
    
    private let HTTPSessionManager: AFHTTPSessionManager
    private let persistenceStore: PersistenceStore
    private let tokenStorage: TokenStorage
    private let serversListUpdater: ServersListUpdater
    private let userLoginManager: UserLoginManager
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.HTTPSessionManager = AFHTTPSessionManager(baseURL: Constants.apiUrl)
        
        self.HTTPSessionManager.requestSerializer = AFJSONRequestSerializer()
        self.HTTPSessionManager.responseSerializer = AFJSONResponseSerializer()
        
        self.tokenStorage = TokenStorage()
        self.persistenceStore = PersistenceStore()
        self.serversListUpdater = ServersListUpdater(persistenceStore: self.persistenceStore, HTTPSessionManager: self.HTTPSessionManager)
        self.userLoginManager = UserLoginManager(HTTPSessionManager: self.HTTPSessionManager)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addContentController(self.serversNavigationController)
        self.serversNavigationController.view.constraint(edgesTo: self.view)
        
        self.addContentController(self.progressViewController)
        self.progressViewController.view.constraint(edgesTo: self.view)
    }
    
    var didShowInitialScreen = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.didShowInitialScreen {
            return
        }
        
        self.didShowInitialScreen = true
        
        if self.tokenStorage.token == nil {
            self.present(self.loginViewControler, animated: false, completion: nil)
        } else {
            self.updateServersList()
        }
    }
    
    // MARK: - Update Servers
    
    private func updateServersList() {
        guard let token = self.tokenStorage.token else {
            return
        }
        
        self.progressViewController.startAnimating()
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear)
        
        animator.addAnimations {
            self.progressViewController.view.alpha = 0
        }
        
        animator.addCompletion { (position) in
            self.removeContentController(self.progressViewController)
        }
        
        self.updateServers(with: token) {
            animator.startAnimation()
        }
    }
    
    private func performLogout() {
        self.serversNavigationController.present(self.loginViewControler, animated: true) {
            self.tokenStorage.token = nil
            self.persistenceStore.performBackgroundTask { (context) in
                self.persistenceStore.resetStore(in: context)
            }
        }
    }
    
    private func updateServers(with token: String, completion: @escaping () -> Void) {
        self.serversListUpdater.updateServersList(with: token) { (error) in
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.localizedFailureReason, message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Ok", style: .default, handler: { (_ ) in
                    if error.code == 401 {
                        self.performLogout()
                    }
                })
                
                alertController.addAction(okayAction)
                alertController.preferredAction = okayAction
                
                self.present(alertController, animated: true) { completion() }
            } else {
                completion()
            }
        }
    }
    
    // MARK: - LoginViewControllerDelegate
    
    func loginViewControllerDidLogin(_ viewController: LoginViewController, token: String) {
        viewController.dismiss(animated: true) {
            self.tokenStorage.token = token
            self.updateServersList()
        }
    }
    
    // MARK: - ServersListViewControllerDelegate
    
    func serverListViewControllerDidSelectLogout(_ view: ServersListViewController) {
        self.performLogout()
    }
}
