//
//  ServerRepositoryProtocol.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

protocol ServerRepositoryProtocol {
    func getServers() -> AnyPublisher<ServersResponse, Error>
}

// MARK: - ServerRepositoryProtocolMock -

final class ServerRepositoryProtocolMock: ServerRepositoryProtocol {
    
   // MARK: - getServers

    var getServersCallsCount = 0
    var getServersCalled: Bool {
        getServersCallsCount > 0
    }
    var getServersReturnValue: AnyPublisher<ServersResponse, Error>!
    var getServersClosure: (() -> AnyPublisher<ServersResponse, Error>)?

    func getServers() -> AnyPublisher<ServersResponse, Error> {
        getServersCallsCount += 1
        return getServersClosure.map({ $0() }) ?? getServersReturnValue
    }
}
