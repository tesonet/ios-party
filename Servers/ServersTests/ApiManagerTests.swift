//
//  ApiManagerTests.swift
//  ServersTests
//
//  Created by Nikita Khodzhaiev on 23.04.2021.
//

import XCTest
@testable import Servers

class ApiManagerTests: XCTestCase {
    
    private var apiManager: ApiManager?
    
    override func setUpWithError() throws {
        let networkService = NetworkService()
        let decodableService = DecodableService()
        let keychainsService = KeychainService()
        
        apiManager = ApiManager(networkService: networkService, decodableService: decodableService, keychainService: keychainsService)
    }

    override func tearDownWithError() throws {
        apiManager = nil
    }
    
    func testLoginReturnValidAuthData() {
                
        let promise = XCTestExpectation(description: "POST auth request")

        apiManager?.login(username: MockLogin.username, password: MockLogin.password) { (result) in
            switch result {
            case .success(let token):
                XCTAssertEqual(token, MockLogin.token, "Auth token should be valid")
                break
            case .failure(_):
                XCTFail("ApiManager should return auth token")
                break
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5.0)
    }
}
