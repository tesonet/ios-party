//
//  File.swift
//  TestProjectTests
//
//  Created by Andrii Popov on 2/25/21.
//

import Foundation
@testable import Testio

struct StubUtils {
    let validJsonData = """
    {
        "token": "some_token"
    }
    """.data(using: .utf8)!
    
    let malformedJsonData = """
    {
        "malformedKey": "some_token"
    }
    """.data(using: .utf8)!
    
    var authorizationData: AuthorizationData {
        AuthorizationData(token: "test_token")
    }
}
