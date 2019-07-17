//
//  RootAppViewController.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

class RootAppViewController: BaseViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegue(identifier: .showSplashScreenViewController)        
    }
    
    override func configureAfterInit() {
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Public Methods
    
    /// Displays given view controller as content view controller.
    ///
    /// - Parameter viewController: A view controller that will be added.
    func display(_ viewController: UIViewController) {
        guard children.first !== viewController else {
            // if current content view controller is the same as a new one - bail out.
            return
        }
        if let currentViewController = children.first {
            transitionFrom(currentViewController, to: viewController)
        } else {
            addViewController(viewController)
        }
    }
    
    // MARK: - Notifications
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUnauthorizedAccessNotification),
                                               name: .unauthorizedAccess,
                                               object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .unauthorizedAccess,
                                                  object: nil)
    }
    
    @objc
    func handleUnauthorizedAccessNotification() {
        print("unauth access")
    }
    
    // MARK: - Private Methods
    
    /// Perform transition from one controller to another.
    ///
    /// - Parameters:
    ///   - fromViewController: A view controller that will be removed.
    ///   - toViewController: A view controller that will be added.
    private func transitionFrom(_ fromViewController: UIViewController,
                                to toViewController: UIViewController) {
        fromViewController.willMove(toParent: nil)
        addChild(toViewController)
        
        toViewController.view.alpha = 0
        toViewController.view.frame = view.bounds
        
        view.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            toViewController.view.alpha = 1
            fromViewController.view.alpha = 0
        }) { _ in
            fromViewController.view.removeFromSuperview()
            fromViewController.removeFromParent()
            toViewController.didMove(toParent: self)
        }
    }
    
    /// Adds view controller as a child with container bouds.
    ///
    /// - Parameter viewController: A view controller that will be added.
    private func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
