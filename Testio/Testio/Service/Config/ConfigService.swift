//
//  ConfigService.swift
//  Testio
//
//  Created by Claus on 28.02.21.
//

import Foundation

final class ConfigService: ConfigServiceProtocol {
    enum Keys {
        static var isDataLoaded: String {
            "isDataLoaded"
        }
    }
    
    let defaults = UserDefaults.standard
    
    var isDataLoaded: Bool {
        get {
            defaults.bool(forKey: Keys.isDataLoaded)
        }
        set {
            defaults.set(newValue, forKey: Keys.isDataLoaded)
        }
    }
}
