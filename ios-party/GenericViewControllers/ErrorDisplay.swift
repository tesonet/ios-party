//
//  ErrorDisplay.swift
//  ios-party
//
//  Created by Joseph on 3/9/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

extension UIViewController {

  private func findRootViewController() -> UIViewController {
    var root = self
    while let parent = root.parent { root = parent }
    return root
  }

  final func showErrorMessage(_ message: String, title: String = "Error") {

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    let presenter = findRootViewController()

    if presenter.viewIfLoaded?.window != nil {

      // present now if VC view is in the hierarchy
      presenter.present(alert, animated: true)

    } else {

      // present a moment later otherwise
      DispatchQueue.main.async {
        presenter.findRootViewController().present(alert, animated: true)
      }

    }

  }

}
