//
//  ParameterEncoderTests.swift
//  Party-iOSTests
//
//  Created by Samet on 28.02.21.
//

import XCTest
@testable import Party_iOS

class ParameterEncoderTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
        
    func testJSONParameterEncoderContentType() {
        let encoder = JSONParameterEncoder()
        var request = URLRequest(url: URL(string: "https://example.com")!)
        let params = ["param1": "val1", "param2": "val2"]
        let sut = encoder.encode(urlRequest: &request, parameters: params)
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testJSONParameterEncoderWithPredefinedContentType() {
        let encoder = JSONParameterEncoder()
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        let params = ["param1": "val1", "param2": "val2"]
        let sut = encoder.encode(urlRequest: &request, parameters: params)
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "text/html")
    }
    
    func testURLParameterEncoderContentType() {
        let encoder = URLParameterEncoder()
        var request = URLRequest(url: URL(string: "https://example.com")!)
        let params = ["param1": "val1", "param2": "val2"]
        let sut = encoder.encode(urlRequest: &request, parameters: params)
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded; charset=utf-8")
    }
    
    func testURLParameterEncoderWithPredefinedContentType() {
        let encoder = URLParameterEncoder()
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        let params = ["param1": "val1", "param2": "val2"]
        let sut = encoder.encode(urlRequest: &request, parameters: params)
        XCTAssertEqual(sut.value(forHTTPHeaderField: "Content-Type"), "text/html")
    }
    
}
