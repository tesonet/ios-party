//
//  TestioApiTests.swift
//  TestioApiTests
//
//  Created by Claus on 28.02.21.
//

import XCTest
@testable import Testio

class TestioApiTests: XCTestCase {

    var apiService: ApiServiceProtocol!
    
    let validCredentials: DomainCredentials = .init(
        username: "tesonet",
        password: "partyanimal"
    )
    
    override func setUpWithError() throws {
        apiService = ApiService(secureStorage: SecureStorageMockService())
    }

    override func tearDownWithError() throws {
        apiService = nil
    }

    func testValidAuth() throws {
        let promise = expectation(description: "Test valid credentials")
        
        apiService.auth(credentials: validCredentials) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("Invalid credentials")
            }
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testnvaldCredentials() {
        let promise = expectation(description: "Test invalid credentials")
        
        let credentials: DomainCredentials = .init(username: "invalid", password: "invalid")
        apiService.auth(credentials: credentials) { result in
            switch result {
            case .success:
                XCTFail("Credentials must fail")
            case .failure:
                break
            }
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testServerList() {
        let promise = expectation(description: "Test server list")
        
        apiService.auth(credentials: validCredentials) { [apiService] result in
            switch result {
            case .success:
                apiService?.loadServers { result in
                    switch result {
                    case let .success(items):
                        XCTAssert(!items.isEmpty)
                    case .failure:
                        XCTFail("Failed to load items")
                    }
                    
                    promise.fulfill()
                }
            case .failure:
                XCTFail("Invalid credentials")
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 5)
    }

}
