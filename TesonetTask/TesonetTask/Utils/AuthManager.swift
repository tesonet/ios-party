//
//  AuthManager.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-18.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

import Locksmith

protocol AuthManagerProtocol {
    func isLoggedIn() -> Bool
    func saveAuthorizationToken(token: String)
    func authorizationHeader() -> Dictionary<String, String>?
    func cleanHeaders()
}

class AuthManager: NSObject, AuthManagerProtocol {
    let auth_key = "TESONET_API_LOGIN"

    func authorizationHeader() -> Dictionary<String, String>? {
        guard let authHeader = Locksmith.loadDataForUserAccount(userAccount: auth_key) as? Dictionary<String, String> else {
            return nil
        }

        return authHeader
    }

    func isLoggedIn() -> Bool {
        return authorizationHeader() != nil
    }

    func saveAuthorizationToken(token: String) {

        var dict = Dictionary<String, String>()
        dict["token"] = token

        do {
            try Locksmith.updateData(data: dict, forUserAccount: auth_key)
        } catch let error as NSError {
            NSLog("saveHeaders error: %@", error)
        }
    }

    func cleanHeaders() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: auth_key)
        } catch let error as NSError {
            NSLog("clean headers error: %@", error)
        }
    }
    
}
