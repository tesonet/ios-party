//
//  Alertable.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import UIKit

protocol Alertable {
    
    /// Shows an alert with title and message.
    ///
    /// - Parameters:
    ///   - title: Alert title.
    ///   - message: Alert message.
    func showAlert(title: String?, message: String?)
    
    
    /// Shows an error alert with a message.
    ///
    /// - Parameter message: An error message displayed in alert.
    func showErrorAlert(message: String)
}

extension Alertable where Self: UIViewController {
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }
}
