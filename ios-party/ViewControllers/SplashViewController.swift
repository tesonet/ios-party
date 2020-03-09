//
//  SplashViewController.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class SplashViewController: ContainerViewController {

  private var loadingVC: LoadingViewController? = nil

  func beginLogin(user: String, pass: String) {
    guard let sb = storyboard else { return }
    let viewController = sb.instantiateViewController(withIdentifier: "load")
    loadingVC = viewController as? LoadingViewController
    moveToNewVC(viewController, animation: .shrink)
    DataLoader.shared.beginLoginSequence(user: user, pass: pass, delegate: self)
  }

}

extension SplashViewController: DataLoaderDelegate {

  func presentSuccess() {
    MainStoryboardController.shared.switchToServerListViewController()
  }

  func presentError(_ error: Error) {

    // show the error

    if let httpError = error as? HTTPError, httpError.code == 401 {
      showErrorMessage("Please check your username and password, then try again.")
    } else {
      showErrorMessage(error.localizedDescription)
    }

    // return to login

    loadingVC = nil
    guard let sb = storyboard else { return }
    moveToNewVC(sb.instantiateViewController(withIdentifier: "login"), animation: .expand)

  }

  func updateProgress(_ task: DataLoaderProgressTask) {
    guard let label = loadingVC?.statusLabel else { return }
    switch task {
      case .loggingIn: label.text = "Logging In..."
      case .gettingServerList: label.text = "Fetching the list..."
    }
  }

}
