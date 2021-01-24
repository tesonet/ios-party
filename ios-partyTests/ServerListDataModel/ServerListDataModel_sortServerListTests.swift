//
//  ServerListDataModel_sortServerListTests.swift
//  ios-partyTests
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import XCTest
@testable import ios_party

class ServerListDataModel_sortServerListTests: XCTestCase {
    
    // MARK: - Declarations
    var dataModel: ServerListDataModelInterface!
    var delegate: ServerListDataModelDelegateMock!
    
    var dataModelDirectAccess: ServerListDataModel {
        return dataModel as! ServerListDataModel
    }
    
    // MARK: - Methods
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        delegate = ServerListDataModelDelegateMock()
        dataModel = ServerListDataModel(delegate: delegate)
    }
    
    override func tearDown() {
        dataModel = nil
        delegate = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    func testSortServerList_ifSortTypeIsDistance_sortsServerListByDistance() {
        
        dataModelDirectAccess.serverList = [ServerEntity(name: "Aaa", distance: 200),
                                            ServerEntity(name: "Bbb", distance: 300),
                                            ServerEntity(name: "Ccc", distance: 100)]
        
        dataModel.sortServerList(by: .distance)
        
        XCTAssertEqual(dataModel.serverList,
                       [ServerEntity(name: "Ccc", distance: 100),
                        ServerEntity(name: "Aaa", distance: 200),
                        ServerEntity(name: "Bbb", distance: 300)])
    }
    
    func testSortServerList_ifSortTypeIsAlphanumerical_sortsServerListByAlphanumerical() {
        
        dataModelDirectAccess.serverList = [ServerEntity(name: "Bbb", distance: 100),
                                            ServerEntity(name: "Ccc", distance: 300),
                                            ServerEntity(name: "Aaa", distance: 200)]
        
        dataModel.sortServerList(by: .alphanumerical)
        
        XCTAssertEqual(dataModel.serverList,
                       [ServerEntity(name: "Aaa", distance: 200),
                        ServerEntity(name: "Bbb", distance: 100),
                        ServerEntity(name: "Ccc", distance: 300)])
    }
    
    func testSortServerList_onCompletion_callsDidSortServerListOnDelegate() {
        dataModelDirectAccess.serverList = [ServerEntity(name: "Aaa", distance: 200),
                                            ServerEntity(name: "Bbb", distance: 300),
                                            ServerEntity(name: "Ccc", distance: 100)]
        
        XCTAssertEqual(delegate.didSortServerList_callCount, 0)
        dataModel.sortServerList(by: .distance)
        XCTAssertEqual(delegate.didSortServerList_callCount, 1)
    }
}
