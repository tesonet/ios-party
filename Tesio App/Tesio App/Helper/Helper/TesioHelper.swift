//
//  TesioHelper.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import RealmSwift

class TesioHelper: NSObject {
    
    // MARK: - Enums
    enum Constant {
        enum Color {
            static let mainLightGreen = UIColor(red: 64.0/255.0, green: 123.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            static let mainDarkBlue = UIColor(red: 47.0/255.0, green: 50.0/255.0, blue: 84.0/255.0, alpha: 1.0)
            static let lightGray = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
        }
        enum Identifiers {
            static let serversList  = "serversListIdentifier"
            static let login        = "loginVCIdentifier"
        }
        static let isAuthorizedKey  = "isAuthorizedKey"
        static let tokenKey         = "loginTokenKey"
        static let usernameKey      = "loginUsernameKey"
        static let passwordKey      = "loginpasswordKey"
    }
    
    public enum Device: String {
        case iPhoneX
        case otherPhone
        case unknown
    }

    public enum LoginError: Error {
        case AuthorizationFailed
        case EmptyUsername
        case EmptyPassword
        case Other
        
        public var title: String {
            switch self {
                case .AuthorizationFailed: return "Authorization failed!"
                case .EmptyUsername: return "Crediantial is missing!"
                case .EmptyPassword: return "Crediantial is missing!"
                case .Other: return "Error!"
            }
        }
        
        public var description: String {
            switch self {
                case .AuthorizationFailed: return "Please check your Username and Password."
                case .EmptyUsername: return "Username cannot be empty!"
                case .EmptyPassword: return "Password cannot be empty"
                case .Other: return "Unhandled error!"
            }
        }
    }
    
    // MARK: - Vars
    static var isAuthorized: Bool {
        get {
            if let isAuthorizedBool = UserDefaults.standard.value(forKey: Constant.isAuthorizedKey) as? Bool {
                return isAuthorizedBool
            }
            return false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.isAuthorizedKey)
        }
    }
    
    static var sortViewHeight: CGFloat {
        var viewHeight: CGFloat = 80.0
        if TesioHelper().currentDevice() == .iPhoneX { viewHeight = 90.0 }
        return viewHeight
    }
    
    
    // MARK: - Methods
    public class func setAsAuthenticated() {
        
    }
    
    public class func setLogin(token: String) {
        KeychainWrapper.standard.set(token, forKey: Constant.tokenKey, withAccessibility: .whenUnlockedThisDeviceOnly)
    }
    
    public class func getLoginToken() -> String? {
        if let token: String = KeychainWrapper.standard.string(forKey: Constant.tokenKey, withAccessibility: .whenUnlockedThisDeviceOnly) {
            return token
        }
        return nil
    }
    
    public class func setUserCrediantials(username: String, password: String) {
        KeychainWrapper.standard.set(username, forKey: Constant.usernameKey, withAccessibility: .whenUnlockedThisDeviceOnly)
        KeychainWrapper.standard.set(password, forKey: Constant.passwordKey, withAccessibility: .whenUnlockedThisDeviceOnly)
    }
    
    public class func getUserCrediantials() -> (String, String)? {
        guard let username: String = KeychainWrapper.standard.string(forKey: Constant.usernameKey, withAccessibility: .whenUnlockedThisDeviceOnly) else {
            return nil
        }
        guard let password: String = KeychainWrapper.standard.string(forKey: Constant.passwordKey, withAccessibility: .whenUnlockedThisDeviceOnly) else {
            return nil
        }
        return (username, password)
    }
    
    private class func deleteUserCrediantialsFromKeychain() {
        KeychainWrapper.standard.removeObject(forKey: Constant.usernameKey, withAccessibility: .whenUnlockedThisDeviceOnly)
        KeychainWrapper.standard.removeObject(forKey: Constant.passwordKey, withAccessibility: .whenUnlockedThisDeviceOnly)
    }
    
    private class func deleteTokenFromKeychain() {
        KeychainWrapper.standard.removeObject(forKey: Constant.tokenKey, withAccessibility: .whenUnlockedThisDeviceOnly)
    }
    
    private class func deleteServersFromDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    public class func cleanOnLogout() {
        isAuthorized = false
        deleteTokenFromKeychain()
        deleteUserCrediantialsFromKeychain()
        deleteServersFromDatabase()
    }
    
    public class func saveServers(_ servers: [Server]) {
        let realm = try! Realm()
        realm.beginWrite()
        for server in servers {
            realm.add(server)
        }
        try! realm.commitWrite()
    }
    
    public class func getServersList() -> [Server]? {
        let realm = try! Realm()
        let servers = realm.objects(Server.self)
        let serversArray = Array(servers)
        return serversArray
    }
    
    public class func showBasicAler(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Device Model
    public func currentDevice() -> Device {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 2436:  return .iPhoneX
                default:    return .otherPhone
            }
        }
        return .unknown
    }
}









