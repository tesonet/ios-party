//
//  LoginServiceTests.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/9/21.
//

import XCTest
@testable import Testio

class LoginServiceTests: XCTestCase {
    
    let stubUtils = StubUtils()
    
    func testLoginServiceShouldReturnValidAuthorizationDataOnSuccess() {
        let apiClientStub = ApiClientStub(isSuccess: true, loadedData: stubUtils.validJsonData)
        
        let dataDecodingClient = DataDecodingClient()
        let dataDecodingService = AuthorizationDataDecodingService(client: dataDecodingClient)
        let service = LoginService(apiClient: apiClientStub, dataDecodingService: dataDecodingService)
        
        service.logIn(username: "", password: "") { result in
            switch result {
            case .success(let authorizationData):
                XCTAssertEqual(authorizationData.token, "some_token", "Authorization token should be the same as in stub json")
            case .failure:
                XCTFail("LoginService should return valid AuthorizationData on success")
            }
        }
    }
    
    func testLoginServiceShouldReturnErrorWhenNetworkRequestWasntSuccessful() {
        let apiClientStub = ApiClientStub(isSuccess: false)
        
        let dataDecodingClient = DataDecodingClient()
        let dataDecodingService = AuthorizationDataDecodingService(client: dataDecodingClient)
        let service = LoginService(apiClient: apiClientStub, dataDecodingService: dataDecodingService)
        
        service.logIn(username: "", password: "") { result in
            switch result {
            case .success:
                XCTFail("LoginService should not succeed on network error")
            case .failure:
                XCTAssertTrue(true)
            }
        }
    }
}
