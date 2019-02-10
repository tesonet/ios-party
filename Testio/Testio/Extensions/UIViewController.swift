//
//  UIViewController.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func indentifier() -> String {
        return String(describing: self)
    }
    
    func showError(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        showInfo(title: "Error", message: message, completion: completion)
    }
    
    func showError(message: String?, fallbackMessage: String, completion: ((UIAlertAction) -> Void)? = nil) {
        var msg = message ?? ""
        if msg.isEmpty {
            msg = fallbackMessage
        }
        showError(message: msg, completion: completion)
    }
    
    func showInfo(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
}
