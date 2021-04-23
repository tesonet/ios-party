//
//  ServersPresenter.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 20.04.2021.
//

import Foundation


enum SortingMethod: String {
    case alphanumerical = "Alphanumerical"
    case distance = "By Distance"
}

class ServersPresenter: ServersPresenterProtocol {
    
    var servers: [ServerModel] {
        return _servers
    }

    private var _servers = [ServerModel]() {
        didSet {
            vc?.reloadUI()
        }
    }
    
    private let apiManager: ApiManagerProtocol
    private var router: RouterProtocol?
    private weak var vc: ServersViewProtocol?
    private weak var storageService: StorageServiceProtocol?

    private var sortMethod = SortingMethod.alphanumerical {
        didSet {
            resort()
            vc?.reloadUI()
        }
    }
    
    required init(view: ServersViewProtocol, apiManager: ApiManagerProtocol, router: RouterProtocol, storageService: StorageServiceProtocol) {
        self.vc = view
        self.apiManager = apiManager
        self.router = router
        self.storageService = storageService
    }
    
    func getServersFromBackend() {
        apiManager.getServers { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let servers):
                    self?.updateLocal(with: servers)
                case .failure(let error):
                    self?.vc?.show(error: error)
                }
            }
        }
    }
    
    func getLocalServers() {
        guard let storageService = storageService else { return }
        let result = storageService.getServers(sortingMethod: sortMethod)
        DispatchQueue.main.async {
            switch result {
            case .success(let servers):
                self._servers = servers
                self.vc?.reloadUI()
            case .failure(let error):
                self.vc?.show(error: error)
            }
        }
    }
    
    func sort() {
        vc?.showSortingMenu(options: [SortingMethod.distance.rawValue, SortingMethod.alphanumerical.rawValue])
    }
    
    func didSelect(option: String) {
        sortMethod = SortingMethod(rawValue: option) ?? .alphanumerical
    }
    
    func logOut() {
        apiManager.logout()
        router?.backToLogin()
    }
    
    private func updateLocal(with servers: [ServerModel]) {
        
        storageService?.save(servers: servers) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.getLocalServers()
                case .failure(let error):
                    self?.vc?.show(error: error)
                }
            }
        }
    }
    
    private func resort() {
        _servers.sort(by: {
            if self.sortMethod == .alphanumerical {
                return $0.name < $1.name
            } else {
                return $0.distance < $1.distance
            }
        })
    }
}
