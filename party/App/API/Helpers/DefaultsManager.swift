//
//  DefaultsManager.swift
//  party
//
//  Created by Paulius on 08/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

final class DefaultsManager {
    
    static let shared = DefaultsManager()
    
    private init() {}
    
    private let serversKey = "serversKey"
    
    private func saveServers(_ servers: [Server]) {
        let userDefaults = UserDefaults.standard
        guard let encodedData: Data = try? NSKeyedArchiver.archivedData(withRootObject: servers, requiringSecureCoding: false) else { return }
        userDefaults.set(encodedData, forKey: serversKey)
        userDefaults.synchronize()
    }
    
    private func getServers() -> [Server]? {
        guard let decoded = UserDefaults.standard.data(forKey: serversKey) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Server] ?? nil
    }
}
