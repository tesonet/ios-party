//
//  Notification+DidLogin.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

extension Notification {
    final class DidLogin: NotificationPostable {
        
        // MARK: - Declarations
        let authorizationToken: String
        
        // MARK: - Methods
        init(authorizationToken: String) {
            self.authorizationToken = authorizationToken
        }
    }
}
