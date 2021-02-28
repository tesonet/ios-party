//
//  SecureStorageMockService.swift
//  TestioApiTests
//
//  Created by Claus on 28.02.21.
//

import Foundation
@testable import Testio

class SecureStorageMockService: SecureStorageServiceProtocol {
    var authToken: String?
}
