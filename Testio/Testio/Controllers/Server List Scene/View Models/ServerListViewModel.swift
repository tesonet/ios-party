//
//  ServerListViewModel.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import UIKit

class ServerListViewModel: NSObject {
    private let serverListService: ServerListService
    private let serverRepository: ServerRespository
    var servers: [Server] = [] {
        didSet {
            didFetchServers?()
        }
    }
    var didFetchServers: (() -> Void)?
    
    override init() {
        self.serverListService = ServerListService()
        self.serverRepository = ServerRespository()
        super.init()
        importServers()
        fetchServers()
    }
    
    func cleanup() {
        serverRepository.wipeUserData()
    }

    private func importServers() {
        serverListService.fetch { [unowned self] (servers, _) in
            guard let servers = servers else { return }
            self.serverRepository.save(servers)
            self.fetchServers()
        }
    }
    
    func fetchServers(sortedBy sortType: ServerRespository.ServerSorting = .name) {
        servers = serverRepository.fetchAll(sortedBy: sortType, ascending: true)
    }
}

extension ServerListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerViewCell.identifier(), for: indexPath) as? ServerViewCell else {
            fatalError()
        }
        let server = servers[indexPath.row]
        cell.setupView(with: server)
        return cell
    }
}
