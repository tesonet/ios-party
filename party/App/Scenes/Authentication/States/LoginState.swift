//
// LoginState.swift
// party
//
// Created by Paulius on 07/05/2020.
// Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

struct LoginState {
    
    private var command: Command?
    private var isFetching: Bool = false
    private var _username: String = ""
    private var _password: String = ""
    
    enum Command: Equatable {
        case submit(LoginForm)
        case openMain
    }
    
    enum Event {
        //optional because text field return optional string. Handling it in reduce
        case typedUsername(String?)
        case typedPassword(String?)
        case tappedLogIn
        case receivedSuccess(LoginResponse)
        case receivedError
    }
    
    var isLoading: Bool {
        return isFetching
    }
    
    var submit: LoginForm? {
        guard case .submit(let loginForm) = command else { return nil }
        return loginForm
    }
    
    var openMain: Void? {
        guard case .openMain = command else { return nil }
        return ()
    }
    
    var isSubmitDisabled: Bool {
        _username.isEmpty || _password.isEmpty
    }
    
    static func reduce(state: LoginState, event: Event) -> LoginState {
        
        var result = state
        result.command = nil
        
        switch event {
        case .receivedError:
            result.isFetching = false
        case .tappedLogIn:
            let loginForm = LoginForm(username: result._username, password: result._password)
            result.command = .submit(loginForm)
            result.isFetching = true
        case .typedUsername(let username):
            result._username = username ?? ""
        case .typedPassword(let password):
            result._password = password ?? ""
        case .receivedSuccess(let token):
            //TODO add keychain manager
            result.command = .openMain
            result.isFetching = false
        }
        
        return result
    }
}
