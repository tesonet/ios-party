//
//  ServerRouter.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import Foundation

protocol ServersPresenterProtocol: class {
    var servers: [ServerModel] { get }
    
    init(view: ServersViewProtocol, apiManager: ApiManagerProtocol, router: RouterProtocol)
    
    func getServers()
    func sort()
    func didSelect(option: String)
    func logOut()
}

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
    
    private var sortMethod = SortingMethod.alphanumerical {
        didSet {
            resort()
            vc?.reloadUI()
        }
    }
    
    required init(view: ServersViewProtocol, apiManager: ApiManagerProtocol, router: RouterProtocol) {
        self.vc = view
        self.apiManager = apiManager
        self.router = router
    }
    
    func getServers() {
        apiManager.getServers { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let servers):
                    self?._servers = servers
                case .failure(let error):
                    self?.vc?.show(error: error)
                }
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
        router?.popToRoot()
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
