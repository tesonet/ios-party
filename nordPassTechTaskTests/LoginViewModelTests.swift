//
//  LoginViewModelTests.swift
//  nordPassTechTaskTests
//
//  Created by Blazej Wdowikowski on 17/04/2021.
//

import XCTest
@testable import nordPassTechTask
import Combine

final class LoginViewModelTests: XCTestCase {
    
    func test_hasCorrectInitialValues() {
        // Arrange
        let repository = LoginRepositoryProtocolMock()
        let appState = AppState(token: nil)

        // Act
        let sut = LoginViewModel(state: LoginState(), with: repository, appState: appState, on: ImmediateScheduler.shared)
        
        // Assert
        XCTAssertEqual(sut.state.password, "")
        XCTAssertEqual(sut.state.username, "")
        XCTAssertFalse(sut.state.isFormValid)
        XCTAssertNil(sut.state.error)
    }
    
    func test_login() {
        // Arrange
        let expectedToken = "fixed.token"
        let repository = LoginRepositoryProtocolMock()
        let appState = AppState(token: nil)
        repository.loginUsernamePasswordReturnValue = expectedToken
        let sut = LoginViewModel(state: LoginState(), with: repository, appState: appState, on: ImmediateScheduler.shared)
        
        // Act
        sut.trigger(.login)
        
        // Assert
        XCTAssertEqual(appState.token, expectedToken)
        XCTAssertNil(sut.state.error)
        XCTAssertTrue(repository.loginUsernamePasswordCalled)
    }
    
    func test_failedLogin() {
        // Arrange
        let repository = LoginRepositoryProtocolMock()
        let appState = AppState(token: nil)
        repository.loginUsernamePasswordReturnValue = nil
        let sut = LoginViewModel(state: LoginState(), with: repository, appState: appState, on: ImmediateScheduler.shared)
        
        // Act
        sut.trigger(.login)
        
        // Assert
        XCTAssertNil(appState.token)
        XCTAssertNotNil(sut.state.error)
        XCTAssertTrue(repository.loginUsernamePasswordCalled)
    }
    
    func test_updateUsername() {
        // Arrange
        let repository = LoginRepositoryProtocolMock()
        let appState = AppState(token: nil)
        let sut = LoginViewModel(state: LoginState(), with: repository, appState: appState, on: ImmediateScheduler.shared)
        let expecteUsername = "fixedUsername"
        
        // Act
        sut.trigger(.updateUsername(expecteUsername))
        
        // Assert
        XCTAssertEqual(sut.state.username, expecteUsername)
    }
    
    func test_updatePassword() {
        // Arrange
        let repository = LoginRepositoryProtocolMock()
        let appState = AppState(token: nil)
        let sut = LoginViewModel(state: LoginState(), with: repository, appState: appState, on: ImmediateScheduler.shared)
        let expectePassword = "fixedPassword"
        
        // Act
        sut.trigger(.updatePassword(expectePassword))
        
        // Assert
        XCTAssertEqual(sut.state.password, expectePassword)
    }
    
    func test_formShouldBeValidOnlyIfUsernameAndPasswordAreNotEmpty() {
        // Arrange
        let repository = LoginRepositoryProtocolMock()
        let appState = AppState(token: nil)
        let sut = LoginViewModel(state: LoginState(), with: repository, appState: appState, on: ImmediateScheduler.shared)
        
        // Act
        sut.trigger(.updateUsername("test"))
        
        // Assert
        XCTAssertFalse(sut.state.isFormValid)
        
        // Act
        sut.trigger(.updatePassword("test"))
        
        // Assert
        XCTAssertTrue(sut.state.isFormValid)
        
        // Act
        sut.trigger(.updateUsername(""))
        
        // Assert
        XCTAssertFalse(sut.state.isFormValid)
    }
}
