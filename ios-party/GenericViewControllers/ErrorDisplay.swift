//
//  ErrorDisplay.swift
//  ios-party
//
//  Created by Joseph on 3/9/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

extension UIViewController {

  final func showErrorMessage(_ message: String, title: String = "Error") {

    // find the root view controller
    var presenter = self
    while let parent = presenter.parent { presenter = parent }

    // show as an alert
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    presenter.present(alert, animated: true)

  }

}
