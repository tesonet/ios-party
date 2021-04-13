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
    var loginUsernamePasswordReceivedArguments: (username: String, password: String)?
    var loginUsernamePasswordReceivedInvocations: [(username: String, password: String)] = []
    var loginUsernamePasswordReturnValue: AnyPublisher<String, Error>!
    var loginUsernamePasswordClosure: ((String, String) -> AnyPublisher<String, Error>)?

    func login(username: String, password: String) -> AnyPublisher<String, Error> {
        loginUsernamePasswordCallsCount += 1
        loginUsernamePasswordReceivedArguments = (username: username, password: password)
        loginUsernamePasswordReceivedInvocations.append((username: username, password: password))
        return loginUsernamePasswordClosure.map({ $0(username, password) }) ?? loginUsernamePasswordReturnValue
    }
}
