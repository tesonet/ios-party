// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain
import KeychainAccess
import ObjectMapper

extension Login {
    func save() {
        let json = self.toJSON()
        let jsonData = try? JSONSerialization.data(
            withJSONObject: json,
            options: [])
        let keychain = Keychain.localStorageKeychain
        keychain[data: "login"] = jsonData
    }
    
    func remove() {
        let keychain = Keychain.localStorageKeychain
        try? keychain.remove("login")
    }
    
    static func load() -> Login? {
        let keychain = Keychain.localStorageKeychain
        guard let jsonData = try? keychain.getData("login"),
            let jsonObject = try? JSONSerialization.jsonObject(
                with: jsonData,
                options: []) else {
                return nil
        }
        
        return try? Mapper<Login>().map(JSONObject: jsonObject) as Login
    }
}
