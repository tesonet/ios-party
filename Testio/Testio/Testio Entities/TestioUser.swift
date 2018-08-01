//
//  TestioUser.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation

struct TestioUser: Codable {

    static let testUser = TestioUser(username: "tesonet", password: "partyanimal")
    
    let username: String
    let password: String
    
}
