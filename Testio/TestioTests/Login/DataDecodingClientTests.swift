//
//  DataTransformingClientTests.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/8/21.
//

import XCTest
@testable import Testio

class DataDecodingClientTests: XCTestCase {
    
    let stubUtils = StubUtils()

    func testDataDecodingServiceShouldCreateEntityFromValidJSON() {
        
        let decodingClient = DataDecodingClient()
        let decodingService = AuthorizationDataDecodingService(client: decodingClient)
        
        let decodingResult = decodingService.value(from: stubUtils.validJsonData)
        switch decodingResult {
        case .success:
            XCTAssert(true)
        case .failure:
            XCTFail( "Decoding client should properly decode value from a valid json")
        }
    }
    
    func testDataDecodingServiceShouldReturnErrorFromInvalidJSON() {
        
        let decodingClient = DataDecodingClient()
        let decodingService = AuthorizationDataDecodingService(client: decodingClient)
        
        let decodingResult = decodingService.value(from: stubUtils.malformedJsonData)
        switch decodingResult {
        case .success:
            XCTFail( "Decoding client should return error while decoding value from malformed json")
        case .failure:
            XCTAssert(true)
        }
    }

}
