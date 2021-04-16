//
//  LoginViewModel.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 13/04/2021.
//

import Foundation
import Combine

final class LoginViewModel<S>: ViewModel where S: Scheduler {
    @Published var state: LoginState
    
    private let repository: LoginRepositoryProtocol
    private let scheduler: S
    private let appState: AppState
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()

    init(state: LoginState = LoginState(username: "tesonet", password: "partyanimal"), with repository: LoginRepositoryProtocol, appState: AppState, on scheduler: S) {
        self.state = state
        self.repository = repository
        self.appState = appState
        self.scheduler = scheduler
    }
    
    func trigger(_ input: LoginInput) {
        switch input {
        case .login:
            repository.login(username: state.username, password: state.password)
                .receive(on: scheduler)
                .catch { [weak self] error -> Empty<String, Never> in
                    guard let error = error as? NetworkError else {
                        self?.state.error = NetworkError.unknownError.errorDescription
                        return Empty<String, Never>(completeImmediately: true)
                    }
                    self?.state.error = error.errorDescription
                    
                    return Empty<String, Never>(completeImmediately: true)
                }
                .sink { [weak self] token in
                    self?.appState.token = token
                }
                .store(in: &bag)
        case .updateLogin(let username):
            state.username = username
        case .updatePassword(let password):
            state.password = password
        }
    }
}

#if DEBUG
extension LoginState {
    static func mock() -> LoginState {
        LoginState(username: "Mocked", password: "Mocked")
    }
}

extension LoginViewModel {
    static func mock(state: LoginState) -> LoginViewModel<ImmediateScheduler> {
        LoginViewModel<ImmediateScheduler>(state: .mock(), with: LoginRepositoryProtocolMock(), appState: .mock() ,on: ImmediateScheduler.shared)
    }
}
#endif

