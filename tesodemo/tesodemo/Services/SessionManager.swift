//
//  SessionManager.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import UIKit

class SessionManager: NSObject {
    
    static let keychainKeyForToken = "TesodemoAuthenticationKey"
    static let notificationKeyForCreatedSession = Notification.Name(rawValue: "notificationKeyForCreatedSession")
    static let sharedInstance = SessionManager()

    var token: String?
    
    var isActive: Bool {
        return token != nil
    }
    
    override init() {
        super.init()
        if let token = KeychainManager.get(SessionManager.keychainKeyForToken) {
            self.token = token
        }
    }
    
    func create(token: String) {
        self.token = token
        let _ = KeychainManager.set(value: token, key: SessionManager.keychainKeyForToken)
        NotificationCenter.default.post(name: SessionManager.notificationKeyForCreatedSession, object: nil)
    }
    func destroy() {
        token = nil
        let _ = KeychainManager.delete(key: SessionManager.keychainKeyForToken)
    }
}
