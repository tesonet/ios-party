//
//  ServersState.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation

struct Servers {
    
    private var isFetching: Bool = true
    private var _servers: [Server] = []
    
    enum Event {
        case tappedLogOut
        case fetchedServers([Server])
    }
    
    enum Command {
        case logOut
    }
    
    var command: Command? = nil
    
    var isLoading: Bool {
        return isFetching
    }
    
    var servers: [Server] {
        return _servers
    }
    
    static func reduce(state: LoginState, event: Event) -> LoginState {
        
        var newState = state
        newState.command = nil

        switch event {
        case .tappedLogOut:
            newState.command = .logOut
        case .fetchedServers(let servers):
            newState._servers = servers
        }
        
        return newState
    }
}
