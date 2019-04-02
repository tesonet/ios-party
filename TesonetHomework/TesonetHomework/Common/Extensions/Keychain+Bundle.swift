// Created by Paulius Cesekas on 02/04/2019.

import KeychainAccess

extension Keychain {
    static var localStorageKeychain: Keychain {
        let service: String
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            service = bundleIdentifier
        } else {
            service = "lt.cesekas.TesonetHomework"
        }
        return Keychain(service: service)
    }
}
