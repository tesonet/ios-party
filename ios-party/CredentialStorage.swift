//
//  CredentialStorage.swift
//  ios-party
//
//  Created by Joseph on 3/7/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import Foundation

final class CredentialStorage {

  static let shared = CredentialStorage()

  var attemptingUser: String = UserDefaults.standard.string(forKey: "username") ?? "" {
    didSet { UserDefaults.standard.set(attemptingUser, forKey: "username") }
  }

  var attemptingPass: String = ""

  private(set) var username: String = ""
  private(set) var password: String = ""
  private(set) var token: String = ""

  func saveAttemptingLoginCredentials() {
    username = attemptingUser
    password = attemptingPass
    attemptingPass = ""
  }

  func saveToken(_ token: String) {
    self.token = token
  }

  func clearAllCredentials() {
    attemptingPass = ""
    username = ""
    password = ""
    token = ""
  }

}
