//
//  AlertControllerFactory.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import UIKit

class AlertControllerFactory {
    
    // MARK: - Constants
    private struct Constants {
        static let genericTitle = "Oops"
        static let genericMessage = "Something went wrong!"
        static let genericOkButtonTitle = "OK"
    }
    
    // MARK: - Methods
    static func showGenericAlert() -> UIAlertController {
        return warningAlertController(title: Constants.genericTitle,
                                      message: Constants.genericMessage,
                                      okButtonTitle: Constants.genericOkButtonTitle)
    }
    
    static func showAlert(title: String,
                   message: String) -> UIAlertController {
        return warningAlertController(title: title,
                                      message: message,
                                      okButtonTitle: Constants.genericOkButtonTitle)
    }
    
    static func showAlert(title: String,
                   message: String,
                   okButtonTitle: String,
                   okButtonTapHandler: (() -> ())?) ->UIAlertController {
        return warningAlertController(title: title,
                                      message: message,
                                      okButtonTitle: okButtonTitle,
                                      okButtonTapHandler: okButtonTapHandler)
    }
    
    // MARK: - Helpers
    private static func warningAlertController(title: String,
                                        message: String,
                                        okButtonTitle: String,
                                        okButtonTapHandler: (() -> ())? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            okButtonTapHandler?()
        }
        
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
}
