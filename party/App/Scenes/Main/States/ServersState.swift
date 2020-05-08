//
// ServersState.swift
// party
//
// Created by Paulius on 08/05/2020.
// Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation

struct ServersState {
    
    private(set) var command: Command? = .fetch
    private var isFetching: Bool = true
    
    enum Command: Equatable {
        case fetch
    }
    
    enum Event {
        case receivedError
        case receivedSuccess(ServersResponse)
    }
    
    var isLoading: Bool {
        return isFetching
    }
    
    var fetch: Void? {
        guard case .fetch? = command else { return nil }
        return ()
    }
    
    static func reduce(state: ServersState, event: Event) -> ServersState {
        
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
