//
//  ServerRepositoryProtocol.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 12/04/2021.
//

import Foundation
import Combine

protocol ServersRepositoryProtocol {
    func getServers() -> AnyPublisher<[ServerDTO], Error>
}

// MARK: - ServerRepositoryProtocolMock -

final class ServersRepositoryProtocolMock: ServersRepositoryProtocol {
    
    var getServersCallsCount = 0
    var getServersCalled: Bool {
        getServersCallsCount > 0
    }
    var getServersReturnValue: [ServerDTO]?
    
    func getServers() -> AnyPublisher<[ServerDTO], Error> {
        getServersCallsCount += 1
        if let returnValue = getServersReturnValue {
            return Just(returnValue).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.unathorized).eraseToAnyPublisher()
        }
    }
}
