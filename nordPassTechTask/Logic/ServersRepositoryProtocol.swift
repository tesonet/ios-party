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
    func getServers() -> AnyPublisher<[ServerDTO], Error> {
        Just([ServerDTO]()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
