//
//  Strings.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 07/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation

enum Strings {
    static let OK = "ok"
    static let Cancel = "cancel"
    static let Error = "error"
    
    enum LoginVC {
        static let usernamePlaceholder = "username.placeholder"
        static let passwordPlaceholder = "password.placeholder"
        static let loginButtonTitle = "loginButton.title"
        static let usernameEmpty = "username.empty"
        static let passwordEmpty = "password.empty"
        static let loginFailed = "login.failed"
    }
    
    enum ServerListVC {
        static let sortButtonTitle = "sortButton.title"
        static let sortByDistance = "sort.byDistance"
        static let sortAlphanumerical = "sort.alphanumerical"
    }
}
