//
//  ServerRouter.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import Foundation

protocol ServersPresenterProtocol: class {
    var servers: [ServerModel] { get }
    
    init(view: ServersViewProtocol, apiManager: ApiManagerProtocol, router: RouterProtocol, storageService: StorageServiceProtocol)
    
    func getServersFromBackend()
    func getLocalServers()
    func sort()
    func didSelect(option: String)
    func logOut()
}
