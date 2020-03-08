//
//  LoginViewController.swift
//  ios-party
//
//  Created by Joseph on 2/22/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

  @IBOutlet weak var userInput: UsernameInput!
  @IBOutlet weak var passInput: PasswordInput!

  override func viewDidLoad() {
    super.viewDidLoad()
    let storage = CredentialStorage.shared
    userInput.field.text = storage.attemptingUser
    passInput.field.text = storage.attemptingPass
  }

  @IBAction func submitLogin() {

    guard let splashVC = parent as? SplashViewController else { return }

    let user = userInput.field.text ?? ""
    let pass = passInput.field.text ?? ""

    if user.isEmpty || pass.isEmpty {
      // TODO: show message
      return
    }

    splashVC.beginLogin(user: user, pass: pass)

  }

}

extension LoginViewController: InputViewReturnDelegate {

  func inputViewDidReturn(_: InputView) {
    submitLogin()
  }

}
