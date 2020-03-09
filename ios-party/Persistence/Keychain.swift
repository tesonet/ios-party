//
//  Keychain.swift
//  ios-party
//
//  Created by Joseph on 3/9/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import Foundation
import Security

struct KeychainEntry {
  let account: String
  let value: String
}

struct Keychain {

  private init() {}

  static func get(_ service: String) -> KeychainEntry? {

    var result: CFTypeRef? = nil

    let error = SecItemCopyMatching([
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecReturnData: true,
      kSecReturnAttributes: true,
    ] as CFDictionary, &result)

    guard error == errSecSuccess else { return nil }
    guard let item = result as? [AnyHashable: Any] else { return nil }

    let account = (item[kSecAttrAccount] as? String) ?? ""
    guard let data = item[kSecValueData] as? Data else { return nil }
    guard let password = String(data: data, encoding: .utf8) else { return nil }

    return KeychainEntry(account: account, value: password)

  }

  static func update(_ service: String, _ entry: KeychainEntry) throws {

    guard let passwordData = entry.value.data(using: .utf8) else {
      throw KeychainError.encodingError
    }

    // first, try to update an existing item
    var error = SecItemUpdate([
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
    ] as CFDictionary, [
      kSecAttrAccount: entry.account,
      kSecValueData: passwordData,
    ] as CFDictionary)

    if error == errSecItemNotFound {

      // otherwise, create a new one
      error = SecItemAdd([
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: entry.account,
        kSecValueData: passwordData,
      ] as CFDictionary, nil)

    }

    if error != errSecSuccess {
      throw KeychainError.otherError(error)
    }

  }

  static func delete(_ service: String) throws {

    let error = SecItemDelete([
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
    ] as CFDictionary)

    if error != errSecSuccess {
      throw KeychainError.otherError(error)
    }

  }

}

enum KeychainError: Error {
  case encodingError
  case otherError(OSStatus)
}
