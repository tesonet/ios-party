//
//  BaseViewController.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Declarations
    lazy var activityIndicator: ActivityIndicatorInterface = UIActivityIndicatorView(customStyle: .appDefault)
    
    // MARK: - Methods
    // MARK: - Activity Indicator
    func showActivityIndicator() {
        activityIndicator.show(inView: view)
    }
    
    func hideActivityIndicator() {
        activityIndicator.hide()
    }
    
    // MARK: Alerts
    func showAlert(title: String, message: String, actionList: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        guard let actionList: [UIAlertAction] = actionList,
              !actionList.isEmpty else {
            let okayAction = UIAlertAction(title: R.string.localizable.okay_action(), style: .default)
            alertController.addAction(okayAction)
            
            present(alertController, animated: true)
            return
        }
        
        for action in actionList {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
}
