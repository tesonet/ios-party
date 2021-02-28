//
//  KeyChainTests.swift
//  Party-iOSTests
//
//  Created by Samet on 28.02.21.
//

import XCTest
@testable import Party_iOS

class KeyChainTests: XCTestCase {
    
    let value = "KEYCHAIN-VALUE"
    let key = "KEYCHAIN-KEY"

    func testSaveToKeyChain() {
        guard let data = value.data(using: .utf8) else{
            XCTFail()
            return
        }
        let result = KeyChain.save(key: key, data: data)
        XCTAssertEqual(result, noErr)
    }
    
    func testLoadFromKeyChain() {
        testSaveToKeyChain() // Save Before Load
        guard let data = KeyChain.load(key: key) else { XCTFail(); return }
        guard let value = String(data: data, encoding: .utf8) else { XCTFail(); return }
        XCTAssertEqual(value, self.value)
    }
    
    func testDeleteFromKeyChain() {
        let result = KeyChain.delete(key: key)
        XCTAssertEqual(result, noErr | errSecItemNotFound)
        let data = KeyChain.load(key: key)
        XCTAssertNil(data)
    }
}
