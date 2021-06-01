//
//  LoginReducer.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 27.05.2021.
//

import Combine
import ComposableArchitecture

enum LoginReducer {
    static let reducer =
        ServersReducer.reducer
        .pullback(state: \.serverState, action: /LoginAction.optionalServers, environment: { $0.create(ServersEnvironment.init) })
        .combined(
            with:
                Reducer<LoginState, LoginAction, GlobalEnvironment<LoginEnvironment>> { state, action, environment in
                    switch action {
                    
                    case .updateUsername(let username):
                        state.username = username
                        return .none
                        
                    case .updatePassword(let password):
                        state.password = password
                        return .none
                        
                    case .navigateToServers(true):
                        return Effect(value: .login)
                        
                    case .navigateToServers(false):
                        state.serverState = nil
                        return .none
                        
                    case .login:
                        state.inProgress = true
                        return environment.login(state.username, state.password)
                            .receive(on: environment.mainQueue)
                            .mapToNSError()
                            .catchToVoidEffect()
                            .map(LoginAction.loginReceived)
                        
                    case .loginReceived(.success):
                        state.inProgress = false
                        state.password = ""
                        state.serverState = ServersState()
                        return .none
                        
                    case .loginReceived(.failure(let error)):
                        state.inProgress = false
                        return Effect(value: error.localizedDescription)
                            .map(LoginAction.errorAlertReceived)
                        
                    case .errorAlertReceived(let message):
                        state.errorAlert = AlertState(
                            title: TextState("Error"),
                            message: TextState(message),
                            dismissButton: .default(.init("OK"))
                        )
                        return .none
                        
                    case .errorAlertDismissed:
                        state.errorAlert = nil
                        return .none

                    case .optionalServers(.action(.logout)):
                        return .merge(
                            .init(value: .navigateToServers(isActive: false)),
                            .fireAndForget(environment.logout)
                        )
                        
                    case .optionalServers:
                        return .none
                    }
                }
        )
}
