//
//  ListStorage.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

final class ListStorage {
    
    static func load() -> [Server]? {
        guard let fileURL = Self.fileURL, let data = FileManager.default.contents(atPath: fileURL.path) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Server].self, from: data)
    }
    
    static func update(servers: [Server]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(servers), let fileURL = Self.fileURL else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
        FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
    }
    
    static var fileURL: URL? {
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cacheURL.appendingPathComponent("servers.json", isDirectory: false)
    }
}
