//
//  ServerListDataModelDelegateMock.swift
//  ios-partyTests
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import Foundation
@testable import ios_party

class ServerListDataModelDelegateMock: ServerListDataModelDelegate {
    
    // MARK: - Declarations
    var didSortServerList_callCount = 0
    
    // MARK: - Methods
    func serverListDataModel(didSortServerList: ServerListDataModelInterface) {
        didSortServerList_callCount += 1
    }
}
