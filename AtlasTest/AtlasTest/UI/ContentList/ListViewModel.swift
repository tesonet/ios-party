//
//  ListViewModel.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

// MARK: - ListViewModel protocol
protocol ListViewModel: AnyObject {
    var servers: [Server] { get set }
    var view: ListViewController? { get set }
    
    init(dependency: DependencyContainer, completionHandler: @escaping ((Server) -> Void))
    func getServers() -> [Server]
    func updateServers(completion: @escaping ([Server]) -> Void )
    func sortServersByName()
    func sortServersByDistance()
    func logout()
}

// MARK: - ListViewModel implementation
class AppListViewModel: ListViewModel {
    var completionHandler: ((Server) -> Void)
    unowned private var dependency: DependencyContainer
    unowned var view: ListViewController?
    var servers: [Server] = []
    
    required init(dependency: DependencyContainer, completionHandler: @escaping ((Server) -> Void)) {
        self.dependency = dependency
        self.completionHandler = completionHandler
    }
    
    func getServers() -> [Server] {
        servers = dependency.dataManager?.getServers() ?? []
        return servers
    }
    
    func updateServers(completion: @escaping ([Server]) -> Void) {
        dependency.apiWorker?.getServers() { [weak self] result in
            switch result {
            case .error(let error):
                self?.dependency.errorHandler?.process(error: error)
            case .response(let result):
                guard let servers = result as? [Server] else { return }
                self?.processResult(servers)
                completion(servers)
            }
        }
    }
    
    func sortServersByName() {
        servers = servers.sorted { $0.name < $1.name }
    }
    
    func sortServersByDistance() {
        servers = servers.sorted { $0.distance < $1.distance }
    }
    
    func logout() {
        dependency.flowStateProcessor?.appFlowState = .notAuthorized
    }
}
  
// MARK: - AppListViewModel private methods
private extension AppListViewModel {
    func processResult(_ servers: [Server]) {
        dependency.dataManager?.saveServers(servers)
        self.servers = dependency.dataManager?.getServers() ?? []
    }
}
