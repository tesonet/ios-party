//
//  ServerStorage.swift
//  ios-party
//
//  Created by Joseph on 3/8/20.
//  Copyright © 2020 Juozas Valancius. All rights reserved.
//

import Foundation

final class ServerStorage {

  static let shared = ServerStorage()

  private let encoder = JSONEncoder()

  private let dataDir: URL?
  private let dataURL: URL?
  private(set) var list: [ServerDescriptor]

  init() {

    dataDir = try? FileManager.default.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )

    dataURL = dataDir?.appendingPathComponent("server_list.json", isDirectory: false)

    if let url = dataURL {
      do {
        let data = try Data(contentsOf: url)
        list = try JSONDecoder().decode(Array<ServerDescriptor>.self, from: data)
      } catch {
        list = []
      }
    } else {
      list = []
    }

  }

  func updateList(_ newList: [ServerDescriptor]) {

    list = newList

    if let url = dataURL {
      try? encoder.encode(newList).write(to: url)
    }

  }

  func clearStorage() {
    if let url = dataURL {
      try? FileManager.default.removeItem(at: url)
    }
  }

}

final class ServerDescriptor: Codable {
  let name: String
  let distance: Double
}
