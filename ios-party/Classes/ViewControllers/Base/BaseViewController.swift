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
}
