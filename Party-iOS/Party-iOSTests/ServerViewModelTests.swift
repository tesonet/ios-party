//
//  ServerViewModelTests.swift
//  Party-iOSTests
//
//  Created by Samet on 28.02.21.
//

import XCTest
@testable import Party_iOS

class ServerViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel() throws {
        let server = Server(name: "SERVER-NAME", distance: 999.0)
        let sut = ServerViewModel(server: server)
        XCTAssertEqual(server.name, sut.name)
        XCTAssertEqual("999.0 km", sut.distance)
    }
}
