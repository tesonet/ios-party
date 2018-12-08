//
//  UIViewController+Helper.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Presents default alert with `OK` action
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

