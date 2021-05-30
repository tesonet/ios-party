//
//  ServersViewState.swift
//  nordPassTechTask
//
//  Created by Mikhail Markin on 27.05.2021.
//

import ComposableArchitecture

indirect enum ServersAction: Equatable {
    case orderSheetButtonTapped
    case orderSheetDismissed
    case errorAlertReceived(message: String, actionMessage: String, action: ServersAction)
    case errorAlertDismissed
    case setSortBy(ServersState.SortedBy)
    case setSortingOrder(ServersState.SortingOrder)
    case fetch
    case fetchReceived(VoidResult<NSError>)
    case serversReceived([Server])
    case logout
}

struct ServersState: Equatable {
    enum SortingOrder: Equatable {
        case descending
        case ascending
        
        func invert() -> SortingOrder {
            switch self {
            case .descending:
                return .ascending
            case .ascending:
                return .descending
            }
        }
    }
    
    enum SortedBy: Equatable {
        case none
        case name
        case distance
    }
    
    var servers: [Server] = []
    var sortingOrder: SortingOrder = .ascending
    var sortedBy: SortedBy = .none
    var orderSheet: ActionSheetState<ServersAction>?
    var errorAlert: AlertState<ServersAction>?
}

extension ServersState {
    var sortedServers: [Server] {
        func sort<Value: Comparable>(by keyPath: KeyPath<Server, Value>) -> (Server, Server) -> Bool {
            return { server1, server2 in
                let value1 = server1[keyPath: keyPath]
                let value2 = server2[keyPath: keyPath]
                switch sortingOrder {
                case .ascending:
                    return  value1 < value2
                case .descending:
                    return value1 > value2
                }
            }
        }
        
        switch sortedBy {
        case .none:
            return servers
        case .distance:
            return servers.sorted(by: sort(by: \.distance))
        case .name:
            return servers.sorted(by: sort(by: \.name))
        }
    }
}
