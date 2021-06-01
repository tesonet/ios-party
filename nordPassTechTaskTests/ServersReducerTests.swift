//
//  ServersReducer.swift
//  nordPassTechTaskTests
//
//  Created by Mikhail Markin on 27.05.2021.
//

import XCTest
@testable import nordPassTechTask
import Combine
import ComposableArchitecture

final class ServersStateTests: XCTestCase {
    func testSorting() {
        let servers = Server.mockList
        var store = ServersState()
        store.servers = servers
        
        store.sortedBy = .name
        store.sortingOrder = .ascending
        XCTAssert(store.sortedServers == servers.sorted { $0.name < $1.name }, "ascending order by name failed")
        store.sortingOrder = .descending
        XCTAssert(store.sortedServers == servers.sorted { $0.name > $1.name }, "descending order by name failed")
        
        store.sortedBy = .distance
        store.sortingOrder = .ascending
        XCTAssert(store.sortedServers == servers.sorted { $0.distance < $1.distance }, "ascending order by distance failed")
        store.sortingOrder = .descending
        XCTAssert(store.sortedServers == servers.sorted { $0.distance > $1.distance }, "descending order by distance failed")
    }
}

final class ServersReducerTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func testOrder() {
        let store = TestStore(
            initialState: ServersState(),
            reducer: ServersReducer.reducer,
            environment: ServersEnvironment.mock
        )

        store.send(.orderSheetButtonTapped) { state in
            func updateSorting(by sort: ServersState.SortedBy) -> ServersAction {
                guard sort != state.sortedBy else { return .setSortingOrder(state.sortingOrder.invert()) }
                return .setSortBy(sort)
            }
            
            state.orderSheet = ActionSheetState(
                title: TextState("Sort by:"),
                buttons: [
                    .cancel(),
                    .default(.init("Distance"), send: updateSorting(by: .distance)),
                    .default(.init("Alphanumerical"), send: updateSorting(by: .name)),
                ]
            )
        }
        
        store.send(.orderSheetDismissed) {
            $0.orderSheet = nil
        }
        
        
        store.send(.setSortBy(.distance)) {
            $0.sortedBy = .distance
        }
        
        store.send(.setSortBy(.name)) {
            $0.sortedBy = .name
        }
        
        store.send(.setSortingOrder(.ascending)) {
            $0.sortingOrder = .ascending
        }
        
        store.send(.setSortingOrder(.descending)) {
            $0.sortingOrder = .descending
        }
        
    }
    
    func testGetServers() {
        let servers = Server.mockList
        
        let store = TestStore(
            initialState: ServersState(),
            reducer: ServersReducer.reducer,
            environment: ServersEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetchServers: { Empty<Void, Error>(completeImmediately: false).eraseToEffect() },
                getServers: { Effect(value: servers) }
                
            )
        )
        
        store.send(.serversSubscribe)
        
        scheduler.advance()
        
        store.receive(.serversReceived(servers)) {
            $0.servers = servers
        }
        
        store.send(.serversUnsubscribe)
        
        scheduler.run()
    }
    
    func testFetchSuccess() {
        let store = TestStore(
            initialState: ServersState(),
            reducer: ServersReducer.reducer,
            environment: ServersEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetchServers: { Effect<Void, Error>(value: ()) },
                getServers: { Empty<[Server], Never>(completeImmediately: false).eraseToEffect() }
                
            )
        )
        
        store.send(.fetch)
        
        scheduler.advance()
        
        store.receive(.fetchReceived(.success))

        scheduler.run()
    }
    
    func testFetchFailure() {
        enum TestError: Error {
            case unknown
            
            var description: String {
                return "unknown"
            }
        }
        
        let error = TestError.unknown as NSError
        
        let store = TestStore(
            initialState: ServersState(),
            reducer: ServersReducer.reducer,
            environment: ServersEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                fetchServers: { Effect<Void, Error>(error: error) },
                getServers: { Empty<[Server], Never>(completeImmediately: false).eraseToEffect() }
                
            )
        )
        
        store.send(.fetch)
        
        scheduler.advance()
        
        store.receive(.fetchReceived(.failure(error)))
        
        scheduler.advance()
        
        store.receive(.errorAlertReceived(error.description)) {
            $0.errorAlert = AlertState(
                title: TextState("Error"),
                message: TextState(error.description),
                dismissButton: .default(.init("Retry"), send: .fetch)
            )
        }

        scheduler.run()
    }
}

