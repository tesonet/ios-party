//
//  LoginViewController.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

  @IBAction func submitLogin() {
    if let splashVC = parent as? SplashViewController {
      splashVC.goToLoad()
    }
  }

}

extension LoginViewController: InputViewReturnDelegate {

  func inputViewDidReturn(_: InputView) {
    submitLogin()
  }

}
