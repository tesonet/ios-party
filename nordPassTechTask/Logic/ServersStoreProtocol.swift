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
    var saveShouldSucceed = true
    func save(_ servers: [ServerDTO]) -> AnyPublisher<Void, Error> {
        saveCallsCount += 1
        if saveShouldSucceed {
            return Just(Void()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: ServersJsonStoreError.unknownError).eraseToAnyPublisher()
        }
        
    }
    
   // MARK: - load

    var loadCallsCount = 0
    var loadCalled: Bool {
        loadCallsCount > 0
    }
    var loadReturnValue: [ServerDTO]?

    func load() -> AnyPublisher<[ServerDTO], Error> {
        loadCallsCount += 1
        if let returnvalue = loadReturnValue {
           return Just(returnvalue).setFailureType(to: Error.self).eraseToAnyPublisher()
       } else {
           return Fail(error: ServersJsonStoreError.unknownError).eraseToAnyPublisher()
       }
    }
}
