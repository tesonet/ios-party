//
//  LoginState.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation

struct LoginState {

    private var isFetching: Bool = false
    private var userName: String = ""
    private var password: String = ""

    enum Event {
        case tappedLogin
        case typedUsername(String)
        case typedPassword(String)
        case receivedAuth(Auth)
        case receivedError
    }
  
    enum Command {
        case login(userName: String, password: String)
        case showServers
    }
    
    var command: Command? = nil
    
    var storeAuth: Auth? = nil
    
    var isLoading: Bool {
        return isFetching
    }
    
    static func reduce(state: LoginState, event: Event) -> LoginState {
        
        var newState = state
        newState.command = nil
        newState.storeAuth = nil

        switch event {
        case .tappedLogin:
            newState.isFetching = true
            #if DEBUG
            newState.command = .login(userName: "tesonet", password: "partyanimal")
            #else
            newState.command = .login(userName: newState.userName, password: newState.password)
            #endif
        case .typedUsername(let newText):
            newState.userName = newText
        case .typedPassword(let newText):
            newState.password = newText
        case .receivedAuth(let auth):
            newState.isFetching = false
            newState.command = .showServers
            newState.storeAuth = auth
        case .receivedError:
            newState.isFetching = false
        }
        
        return newState
    }
}
