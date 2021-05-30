//
//  LoginReducerTests.swift
//  nordPassTechTaskTests
//
//  Created by Mikhail Markin on 28.05.2021.
//

import XCTest
@testable import nordPassTechTask
import Combine
import ComposableArchitecture

final class LoginStateTests: XCTestCase {
    func testFormIsValid() {
        var store = LoginState()
        
        XCTAssert(!store.isFormValid, "form should be not valid")
        store.username = "some"
        XCTAssert(!store.isFormValid, "form should be not valid")
        store.password = "some"
        XCTAssert(store.isFormValid, "form should be valid")
        store.username = ""
        XCTAssert(!store.isFormValid, "form should be not valid")
    }
}

final class LoginReducerTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func testUserName() {
        let store = TestStore(
            initialState: LoginState(),
            reducer: LoginReducer.reducer,
            environment: LoginEnvironment.mock
        )
        
        let testName = "some name"
        
        store.send(.updateUsername(testName)) {
            $0.username = testName
        }
    }
    
    func testPassword() {
        let store = TestStore(
            initialState: LoginState(),
            reducer: LoginReducer.reducer,
            environment: LoginEnvironment.mock
        )
        
        let testPass = "some name"
        
        store.send(.updatePassword(testPass)) {
            $0.password = testPass
        }
    }
    
    func testLoginSuccess() {
        let token = ""
        
        let store = TestStore(
            initialState: LoginState(),
            reducer: LoginReducer.reducer,
            environment: LoginEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                login: { _,_ in Effect<String, NSError>.future { $0(.success(token)) } }
            )
        )
        
        store.send(.login) {
            $0.inProgress = true
        }
        
        scheduler.advance()
        
        store.receive(.loginReceived(.success(token))) {
            $0.inProgress = false
            $0.serverState = ServersState()
        }
        
        scheduler.run()
    }
    
    func testLoginFailure() {
        final class TestError: NSError {
            override var description: String { "test error" }
        }
        
        let error = TestError()
        
        let store = TestStore(
            initialState: LoginState(),
            reducer: LoginReducer.reducer,
            environment: LoginEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                login: { _,_ in Effect<String, NSError>(error: error) }
            )
        )
        
        store.send(.login) {
            $0.inProgress = true
        }
        
        scheduler.advance()
        
        store.receive(.loginReceived(.failure(error))) {
            $0.inProgress = false
        }
        
        scheduler.advance()
        
        store.receive(.errorAlertReceived(error.description)) {
            $0.errorAlert = AlertState(
                title: TextState("Error"),
                message: TextState(error.description),
                dismissButton: .default(.init("OK"))
            )
        }
        
        scheduler.run()
    }
}
