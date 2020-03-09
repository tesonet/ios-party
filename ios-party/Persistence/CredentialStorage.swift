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

  private init() {

    if let credentials = Keychain.get("login") {
      username = credentials.account
      password = credentials.value
    }

    if let savedToken = Keychain.get("token") {
      token = savedToken.value
    }

  }

  func saveAttemptingLoginCredentials() {

    username = attemptingUser
    password = attemptingPass
    attemptingPass = ""

    try? Keychain.update("login", KeychainEntry(account: username, value: password))

  }

  func saveToken(_ token: String) {
    self.token = token
    try? Keychain.update("token", KeychainEntry(account: "", value: token))
  }

  func clearAllCredentials() {

    attemptingPass = ""
    username = ""
    password = ""
    token = ""

    try? Keychain.delete("login")
    try? Keychain.delete("token")

  }

}
