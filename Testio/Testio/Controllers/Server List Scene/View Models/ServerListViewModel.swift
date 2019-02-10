//
//  ServerListViewModel.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation

class ServerListViewModel {
    private let serverListService: ServerListService
    
    init() {
        self.serverListService = ServerListService()
        fetchServerList()
    }
    
    // Load data from API in background
    // For UI use the data from Realm
    // Should I use RxRealm
    func fetchServerList() {
        serverListService.fetch { (servers, error) in
            print(servers)
        }
    }
}
