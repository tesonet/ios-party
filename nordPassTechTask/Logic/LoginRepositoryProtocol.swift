//
//  LoginRepositoryProtocol.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

protocol LoginRepositoryProtocol {
    func login(username: String, password: String) -> AnyPublisher<String, Error>
}

// MARK: - LoginRepositoryProtocolMock -

final class LoginRepositoryProtocolMock: LoginRepositoryProtocol {
    
   // MARK: - login

    var loginUsernamePasswordCallsCount = 0
    var loginUsernamePasswordCalled: Bool {
        loginUsernamePasswordCallsCount > 0
    }
    var loginUsernamePasswordReturnValue: String?

    func login(username: String, password: String) -> AnyPublisher<String, Error> {
        loginUsernamePasswordCallsCount += 1
        if let returnValue = loginUsernamePasswordReturnValue {
            return Just(returnValue).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.unathorized).eraseToAnyPublisher()
        }
    }
}
