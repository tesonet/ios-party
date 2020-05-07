//
// LoginState.swift
// party
//
// Created by Paulius on 07/05/2020.
// Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

struct LoginState {
    
    private(set) var command: Command?
    private var isFetching: Bool = false
    
    enum Command: Equatable {
        case submit
    }
    
    enum Event {
        case typedUsername
        case typedPassword
        case tappedLogIn
        case receivedSuccess
    }
    
    var isLoading: Bool {
        return isFetching
    }
    
    var fetch: Void? {
        guard case .submit? = command else { return nil }
        return ()
    }
    
    static func reduce(state: LoginState, event: Event) -> LoginState {
        
        var result = state
        result.command = nil
        
        switch event {
        case .receivedError:
            result.isFetching = false
        case .receivedSuccess:
            result.isFetching = false
        }
        
        return result
    }
}
