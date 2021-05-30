//
//  ServersJsonStoreTests.swift
//  nordPassTechTaskTests
//
//  Created by Blazej Wdowikowski on 17/04/2021.
//

import XCTest
@testable import nordPassTechTask
import Combine

final class ServersJsonStoreTest: XCTestCase {
    
    func test_saveAndLoad() {
        // Arrange
        let expectedServers = [Server(name: "fixedServer", distance: 0)]
        let sut = JsonServersStore()
        
        // Act
        _ = sut.setServers(expectedServers)
            .receive(on: ImmediateScheduler.shared)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    // Assert
                    XCTFail("Shouldn't fail")
                }
            }, receiveValue: { _ in })
        
        _ = sut.getServers()
            .receive(on: ImmediateScheduler.shared)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    // Assert
                    XCTFail("Shouldn't fail")
                }
            }, receiveValue: { servers in
                // Assert
                XCTAssertEqual(servers, expectedServers)
            })
        
    }
}


