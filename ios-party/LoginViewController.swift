//
//  LoginViewController.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class LoginViewController: KeyboardSafeAreaViewController {

  @IBAction func submitLogin() {
    performSegue(withIdentifier: "load", sender: self)
  }
  
}

extension LoginViewController: InputViewReturnDelegate {

  func inputViewDidReturn(_: InputView) {
    submitLogin()
  }

}
