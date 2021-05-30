//
//  LoginState.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 27.05.2021.
//

import ComposableArchitecture

enum LoginAction: Equatable {
    case updateUsername(String)
    case updatePassword(String)
    case navigateToServers(isActive: Bool)
    case login
    case loginReceived(VoidResult<NSError>)
    case errorAlertReceived(String)
    case errorAlertDismissed
    case optionalServers(LifecycleAction<ServersAction>)
}

struct LoginState: Equatable {
    var username: String = "tesonet"
    var password: String = "partyanimal"
    var errorAlert: AlertState<LoginAction>?
    var inProgress: Bool = false
    var serverState: ServersState?
}

extension LoginState {
    var isFormValid: Bool {
        return !username.isEmpty && !password.isEmpty
    }
    
    var navigatedToServers: Bool {
        return serverState != nil
    }
}
