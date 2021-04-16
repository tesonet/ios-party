//
//  ServersStore.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 16/04/2021.
//

import Foundation
import Combine

protocol ServersStoreProtocol {
    func save(_ servers: [ServerDTO]) -> AnyPublisher<Void, Error>
    func load() -> AnyPublisher<[ServerDTO], Error>
}

// MARK: - ServersStoreProtocolMock -

final class ServersStoreProtocolMock: ServersStoreProtocol {
    
   // MARK: - save

    var saveCallsCount = 0
    var saveCalled: Bool {
        saveCallsCount > 0
    }
    var saveReceivedServers: [ServerDTO]?
    var saveReceivedInvocations: [[ServerDTO]] = []
    var saveReturnValue: AnyPublisher<Void, Error> = Just(Void()).setFailureType(to: Error.self).eraseToAnyPublisher()
    var saveClosure: (([ServerDTO]) -> AnyPublisher<Void, Error>)?

    func save(_ servers: [ServerDTO]) -> AnyPublisher<Void, Error> {
        saveCallsCount += 1
        saveReceivedServers = servers
        saveReceivedInvocations.append(servers)
        return saveClosure.map({ $0(servers) }) ?? saveReturnValue
    }
    
   // MARK: - load

    var loadCallsCount = 0
    var loadCalled: Bool {
        loadCallsCount > 0
    }
    var loadReturnValue: AnyPublisher<[ServerDTO], Error> = Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    var loadClosure: (() -> AnyPublisher<[ServerDTO], Error>)?

    func load() -> AnyPublisher<[ServerDTO], Error> {
        loadCallsCount += 1
        return loadClosure.map({ $0() }) ?? loadReturnValue
    }
}
