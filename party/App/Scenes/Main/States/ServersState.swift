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
    private var _servers: [Server] = []
    private var _sortType: Server.SortType = .alphanumerical
    
    enum Command: Equatable {
        case fetch
        case logOut
    }
    
    enum Event {
        case receivedError
        case receivedSuccess([Server])
        case tappedLogout
        case tappedSort(by: Server.SortType)
    }
    
    var isLoading: Bool {
        return isFetching
    }
    
    var fetch: Void? {
        guard case .fetch = command else { return nil }
        return ()
    }
    
    var logout: Void? {
        guard case .logOut = command else { return nil }
        return ()
    }
    
    var servers: [Server] {
        return _servers.sorted {
            _sortType == .distance ? $0.distance < $1.distance : $0.name < $1.name
        }
    }
    
    static func reduce(state: ServersState, event: Event) -> ServersState {
        
        var result = state
        result.command = nil
        
        switch event {
        case .receivedError:
            result.isFetching = false
        case .receivedSuccess(let servers):
            result._servers = servers
            result.isFetching = false
        case .tappedSort(let type):
            result._sortType = type
        case .tappedLogout:
            result.command = .logOut
        }
        
        return result
    }
}
