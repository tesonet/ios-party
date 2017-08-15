//
//  AppDelegate.swift
//  iOS Party
//
//  Created by Justas Liola on 14/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.isStatusBarHidden = true
        
        if API.Headers.isLoggedIn() {
            let listView = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(ListViewController.self)")
            window?.rootViewController = listView
        }
        
        return true
    }

}


import Unbox
extension AppDelegate {
    
    class func catchError(_ data: Data) {
//        guard let error: Error = try? unbox(data: data) else { return }
//        AppDelegate.showAlert(message: error.message)
    }
    
    class func showAlert(message: String, title: String? = nil, cancelTitle: String = "Ok", cancelStyle: UIAlertActionStyle = .cancel, extraAction action: (String, ()->())? = nil, cancelAction: (()->())? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let (title, action) = action {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in action() }))
        }
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: cancelStyle, handler: { _ in cancelAction?() }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
