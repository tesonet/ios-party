//
//  AppDelegate+AuthorizationNotifications.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

extension AppDelegate {
    
    func startObservingAuthorizationNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDidFinishLoginNotification),
                                               name: Notification.DidLogin.name,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDidLogoutNotification),
                                               name: Notification.DidLogout.name,
                                               object: nil)
    }
    
    @objc func didReceiveDidFinishLoginNotification() {
        switchToDataLoadingMode()
    }
    
    @objc func didReceiveDidLogoutNotification() {
        switchToLoggedOutMode()
    }
}
