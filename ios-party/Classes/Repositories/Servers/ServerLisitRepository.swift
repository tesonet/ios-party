//
//  serverLisitRepository.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation

// In memory storing
class ServerListRepository {
    
    // MARK: - Declarations
    static let shared: ServerListRepository = ServerListRepository()
    
    private var serverList: [ServerListEntity] = []
    
    // MARK: - Methods
    public func setServerList(_ serverList: [ServerListEntity]) {
        self.serverList = serverList
    }
    
    public func currentServerList() -> [ServerListEntity] {
        return self.serverList
    }
    
    public func removeServer(_ server: ServerListEntity) {
        if let index = serverList.firstIndex(of: server) {
            serverList.remove(at: index)
        }
    }
}
