//
//  API+Auth.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import PromiseKit

class AuthServiceManager: ServiceManager {
    func login(withUsername username: String, password: String) -> Promise<Data> {
        return post("http://playground.tesonet.lt/v1/tokens", parameters: ["username": username, "password": password])
    }
}
