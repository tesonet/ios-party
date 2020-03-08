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

  private(set) var username: String = ""
  private(set) var password: String = ""
  private(set) var token: String = ""

  func saveLoginCredentials(user: String, pass: String) {
    username = user
    password = pass
  }

  func saveToken(_ token: String) {
    self.token = token
  }

  func clearAllCredentials() {
    username = ""
    password = ""
    token = ""
  }

}
