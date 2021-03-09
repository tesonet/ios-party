//
//  EndpointTests.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/8/21.
//

import XCTest
@testable import Testio

class EndpointTests: XCTestCase {
    
    let loginEndpoint = Endpoint.logIn(user: "user", password: "password")
    let serversEndpoint = Endpoint.servers(token: "token")
    
    
    func testLoginEndpointShouldReturnProperHostValue() {
        XCTAssertEqual(loginEndpoint.host, "playground.tesonet.lt", "Login endpoint should return a proper host")
    }
    
    func testServersEndpointShouldReturnProperHostValue() {
        XCTAssertEqual(serversEndpoint.host, "playground.tesonet.lt", "Servers endpoint should return a proper host")
    }
    
    func testLoginEndpointShouldReturnProperPathValue() {
        XCTAssertEqual(loginEndpoint.path, "/v1/tokens", "Login endpoint should return a proper path")
    }
    
    func testServersEndpointShouldReturnProperPathValue() {
        XCTAssertEqual(serversEndpoint.path, "/v1/servers", "Servers endpoint should return a proper path")
    }
    
    func testLoginEndpointShouldReturnProperShemeValue() {
        XCTAssertEqual(loginEndpoint.scheme, "https", "Login endpoint should return a proper sheme")
    }
    
    func testServersEndpointShouldReturnProperShemeValue() {
        XCTAssertEqual(serversEndpoint.scheme, "http", "Servers endpoint should return a proper sheme")
    }
    
    func testLoginEndpointShouldReturnProperHeadersValue() {
        XCTAssertEqual(loginEndpoint.headers, ["Content-Type": "application/json"] , "Login endpoint should return a proper headers")
    }
    
    func testServersEndpointShouldReturnProperHeadersValue() {
        XCTAssertEqual(serversEndpoint.headers, ["Authorization": "Bearer token", "Content-Type": "application/json"] , "Servers endpoint should return a proper headers")
    }
    
    func testLoginEndpointShouldReturnProperURLValue() {
        XCTAssertEqual(loginEndpoint.url.absoluteString, "https://playground.tesonet.lt/v1/tokens" , "Login endpoint should return a proper URL")
    }
    
    func testServersEndpointShouldReturnProperURLValue() {
        XCTAssertEqual(serversEndpoint.url.absoluteString, "http://playground.tesonet.lt/v1/servers" , "Servers endpoint should return a proper URL")
    }

}
