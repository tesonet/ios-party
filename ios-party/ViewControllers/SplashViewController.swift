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
    moveToNewVC(sb.instantiateViewController(withIdentifier: "load"))
    DataLoader.shared.beginLoginSequence(user: user, pass: pass, delegate: self)
  }

}

extension SplashViewController: DataLoaderDelegate {

  func presentSuccess(_ list: ServerListResponseData) {
    // placeholder implementation
    let alert = UIAlertController(title: "success", message: "ok", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true)
    print(list.count, "items")
    for item in list {
      print(item)
    }
  }

  func presentError(_ error: Error) {
    // placeholder implementation
    let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true)
    print(error)
  }

}
