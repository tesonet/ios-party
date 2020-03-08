//
//  SplashViewController.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class SplashViewController: ContainerViewController {

  func beginLogin(user: String, pass: String) {
    guard let sb = storyboard else { return }
    moveToNewVC(sb.instantiateViewController(withIdentifier: "load"), animation: .shrink)
    DataLoader.shared.beginLoginSequence(user: user, pass: pass, delegate: self)
  }

}

extension SplashViewController: DataLoaderDelegate {

  func presentSuccess() {
    MainStoryboardController.shared.switchToServerListViewController()
  }

  func presentError(_ error: Error) {

    // construct the error messagee

    let errorMessage: String

    if let httpError = error as? HTTPError {
      if httpError.code == 401 {
        errorMessage = "Please check your username and password, then try again."
      } else {
        errorMessage = "Something went wrong (\(httpError.code) \(httpError.message))"
      }
    } else {
      errorMessage = error.localizedDescription
    }

    // display the message

    let alert = UIAlertController(
      title: "Error",
      message: errorMessage,
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true)

    // return to login

    guard let sb = storyboard else { return }
    moveToNewVC(sb.instantiateViewController(withIdentifier: "login"), animation: .expand)

  }

}
