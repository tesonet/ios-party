//
//  LoginCoordinator.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation
import UIKit

class LoginCoordinator: LoginDelegate {
    var loginViewController: UIViewController?
    
    func start() {
        loginViewController = nil
        loginViewController = LoginViewController.
        guard let loginVC = loginViewController else { return }
        displayLogin()
    }
    
    // MARK: -
    func displayLogin(viewController: UIViewController, presentingViewController: UIViewController) {
        let modalViewController = viewController
        viewController.modalPresentationStyle = .overCurrentContext
        let presentingVC = presentingViewController
        presentingVC.definesPresentationContext = true
        presentingVC.present(modalViewController, animated: true, completion: nil)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let appCoordinator = appDelegate.coordinator else { return }
        appCoordinator.contentRootPresentedVC = viewController
        subscribeToPageLoadedNotification()
        subscribeToDismissPageNotification()
    }
    
    func subscribeToPageLoadedNotification() {
        Backbase.registerObserver(self, selector: #selector(pageLoaded(notification:)), forEvent: "bb.item.loaded")
    }
    
    @objc
    func pageLoaded(notification: Notification) {
        
    }
    
    func unsubscribeFromPageLoadedNotification() {
        Backbase.unregisterObserver(self, forEvent: "bb.item.loaded")
    }
    
    func subscribeToDismissPageNotification() {
        Backbase.registerObserver(self, selector: #selector(dismissBackbaseTopPage(notification:)), forEvent: "native:dismiss-backbase")
    }
    
    func unsubscribeFromDismissPageNotification() {
        Backbase.unregisterObserver(self, forEvent: "native:dismiss-backbase")
    }
    
    func dismissCurrencyConverter(completion: (() -> Void)? = nil) {
        unsubscribeFromDismissPageNotification()
        unsubscribeFromPageLoadedNotification()
        currencyConverterViewController?.dismiss(animated: true) { [weak self] in
            self?.currencyConverterViewController?.transitioningDelegate = nil
            self?.currencyConverterViewController = nil
            self?.presenterViewController = nil
            guard let completionHandler = completion else { return }
            completionHandler()
        }
    }
    
    @objc
    func dismissBackbaseTopPage(notification: Notification) {
        dismissCurrencyConverter()
    }
    
    func onCurrencyConverterCompletion() {
        #if DEBUG
        print("CURRENCY CONVERTER COMPLETION")
        #endif
    }
}
