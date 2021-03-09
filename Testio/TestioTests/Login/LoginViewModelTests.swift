//
//  LoginViewModelTests.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/9/21.
//

import XCTest
@testable import Testio

class LoginViewModelTests: XCTestCase {

    let stubUtils = StubUtils()
    
    var coordinatorMock: LoginCoordinatorMock!
    var apiClientStub: ApiClientStub!
    var serviceStub: LoginServiceStub!
    
    override func setUp() {
        super.setUp()
        coordinatorMock = LoginCoordinatorMock(with: UIViewController())
        apiClientStub = ApiClientStub(isSuccess: true, loadedData: stubUtils.validJsonData)
        serviceStub = LoginServiceStub(apiClient: apiClientStub, isLoadingData: false)
    }
    
    override func tearDown() {
        coordinatorMock = nil
        apiClientStub = nil
        serviceStub = nil
        super.tearDown()
    }
    
    func testLoginViewModelShouldCallCoordinatorsDisplayMessageAfterDataLoadingError() {
        serviceStub.successfullyLoaded = false

        let viewModel = LoginViewModel(loginService: serviceStub, coordinator: coordinatorMock)
        let onDisplayMessageCalledExpectation = XCTestExpectation(description: "Display message got called expectation")

        coordinatorMock.onDisplayMessage = {
            onDisplayMessageCalledExpectation.fulfill()
        }
        viewModel.login(username: "", password: "")
        wait(for: [onDisplayMessageCalledExpectation], timeout: 0.5)
    }
    
    func testLoginViewModelShouldCallCoordinatorsDisplayNextScreenMessageAfterDataLoadingSuccess() {
        serviceStub.successfullyLoaded = true
        serviceStub.loadedAuthorizationData = stubUtils.authorizationData
        let viewModel = LoginViewModel(loginService: serviceStub, coordinator: coordinatorMock)
        let onDisplayNextScreenCalledExpectation = XCTestExpectation(description: "Display message got called expectation")

        coordinatorMock.onDisplayNextScreen = {
            onDisplayNextScreenCalledExpectation.fulfill()
        }
        viewModel.login(username: "", password: "")
        wait(for: [onDisplayNextScreenCalledExpectation], timeout: 0.5)
    }

}
