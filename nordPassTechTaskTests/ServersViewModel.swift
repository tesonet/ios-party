//
//  ServersViewModel.swift
//  nordPassTechTaskTests
//
//  Created by Blazej Wdowikowski on 17/04/2021.
//

import XCTest
@testable import nordPassTechTask
import Combine

final class ServersViewModelTests: XCTestCase {
    
    func test_hasCorrectInitialValues() {
        // Arrange
        let repository = ServersRepositoryProtocolMock()
        let store = ServersStoreProtocolMock()
        
        // Act
        let sut = ServersViewModel(state: ServersState(), with: repository, store: store, on: ImmediateScheduler.shared)
        
        // Assert
        XCTAssertEqual(sut.state.servers, [])
        XCTAssertEqual(sut.state.sortingOrder, .descending)
        XCTAssertEqual(sut.state.sortedBy, .none)
        XCTAssertFalse(sut.state.isOrderSheetPresented)
        XCTAssertNil(sut.state.error)
    }
    
    func test_shouldUseStoredServers_whenRemoteIsUnavailable() {
        // Arrange
        let repository = ServersRepositoryProtocolMock()
        repository.getServersReturnValue = nil
        
        let expectedStoredServers = [ServerDTO(name: "test", distance: 0)]
        let store = ServersStoreProtocolMock()
        store.loadReturnValue = expectedStoredServers
        
        let sut = ServersViewModel(state: ServersState(), with: repository, store: store, on: ImmediateScheduler.shared)
        
        // Act
        sut.trigger(.initialFetch)
        
        // Assert
        XCTAssertEqual(sut.state.servers, expectedStoredServers)
        XCTAssertEqual(sut.state.error?.reason, NetworkError.unathorized.localizedDescription)
        XCTAssertTrue(store.loadCalled)
        XCTAssertTrue(repository.getServersCalled)
    }
    
    func test_shouldUseRemoteServers() {
        // Arrange
        let expectedRepositoryServers = [ServerDTO(name: "repository", distance: 0)]
        let repository = ServersRepositoryProtocolMock()
        repository.getServersReturnValue = expectedRepositoryServers
        
        let expectedStoredServers = [ServerDTO(name: "stored", distance: 0)]
        let store = ServersStoreProtocolMock()
        store.loadReturnValue = expectedStoredServers
        
        let sut = ServersViewModel(state: ServersState(), with: repository, store: store, on: ImmediateScheduler.shared)
        
        // Act
        sut.trigger(.initialFetch)
        
        // Assert
        XCTAssertEqual(sut.state.servers, expectedRepositoryServers)
        XCTAssertTrue(store.loadCalled)
        XCTAssertNil(sut.state.error)
        XCTAssertTrue(repository.getServersCalled)
    }
    
    func test_shouldReorderServers() {
        // Arrange
        let repository = ServersRepositoryProtocolMock()
        repository.getServersReturnValue = nil
        
        let expectedStoredServers = [ServerDTO(name: "1stored", distance: 1), ServerDTO(name: "2stored", distance: 0)]
        let store = ServersStoreProtocolMock()
        store.loadReturnValue = expectedStoredServers
        
        let sut = ServersViewModel(state: ServersState(), with: repository, store: store, on: ImmediateScheduler.shared)
        sut.trigger(.initialFetch)
        XCTAssertEqual(sut.state.servers, expectedStoredServers)
        
        // Act
        sut.trigger(.updateSortedBy(.distance))
        
        // Assert
        let sortedByDistance = expectedStoredServers.sorted { $0.distance > $1.distance }
        XCTAssertEqual(sut.state.servers, sortedByDistance)
        
        // Act
        sut.trigger(.updateSortedBy(.name))
        
        // Assert
        let sortedByName = expectedStoredServers.sorted { $0.name > $1.name }
        XCTAssertEqual(sut.state.servers, sortedByName)
        
    }
}
