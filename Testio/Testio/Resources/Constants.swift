//
//  Constants.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation

enum AppConfig {
    enum InfoPlistKeys {
        static let ApiHost = "ApiHost"
    }
    
    enum KeychainSettings {
        static let service = Bundle.main.bundleIdentifier!
        static let authorizationToken = "kAuthorizationToken"
    }
}

extension Notification.Name {
    static let UserLoggedOut = NSNotification.Name("UserLoggedOut")
}
