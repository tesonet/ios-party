//
//  ServerListDataModel.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

protocol ServerListDataModelDelegate: class {
    func serverListDataModelDidStartLoading(_ dataModel: ServerListDataModel)
    func serverListDataModelDidLoad(_ dataModel: ServerListDataModel)
    func serverListDataModelDidSortData(_ dataModel: ServerListDataModel)
    func serverListDataModel(_ dataModel: ServerListDataModel, didFailWithError error: Error)
}

class ServerListDataModel {
    
    enum SortType {
        case distance
        case alphanumerical
    }
    
    // MARK: - Dependencies
    
    let apiClient: ApiClient
    let databaseManager: DatabaseManager
    
    // MARK: - States
    
    var data: [ServerCellViewModel] = []
    
    weak var delegate: ServerListDataModelDelegate?
    
    private(set) var isLoading: Bool = false
    
    // MARK: - Init
    
    init(delegate: ServerListDataModelDelegate,
         apiClient: ApiClient,
         databaseManager: DatabaseManager) {
        self.delegate = delegate
        self.apiClient = apiClient
        self.databaseManager = databaseManager
    }
    
    // MARK: - Public Methods
    
    /// Loads data from API.
    func loadData() {
        guard isLoading == false else {
            return
        }
        isLoading = true
        
        delegate?.serverListDataModelDidStartLoading(self)
        
        startLoadingData()
    }
    
    /// Sorts list of data.
    ///
    /// - Parameter type: A sorting style.
    func sort(by type: SortType) {
        switch type {
        case .alphanumerical:
            data.sort(by: { $0.serverName < $1.serverName })
        case .distance:
            data.sort(by: { $0.distance < $1.distance })
        }
        delegate?.serverListDataModelDidSortData(self)
    }
    
    // MARK: - Private Methods
    
    /// Starts loading server list. First tries to load them from persistent storage, if fails - loads remote data and caches.
    private func startLoadingData() {
        loadCached { [weak self] (servers) in
            if servers.isEmpty {
                self?.loadRemoteAndCache()
            } else {
                self?.handleSuccess(with: servers)
            }
        }
    }
    
    /// Handles failed request.
    private func handleFailure(with error: Error) {
        isLoading = false
        delegate?.serverListDataModel(self, didFailWithError: error)
    }
    
    /// Handles successfull response.
    private func handleSuccess(with data: [Server]) {
        isLoading = false
        self.data = data.map { ServerCellViewModel(server: $0) }
        delegate?.serverListDataModelDidLoad(self)
    }
    
    // MARK: - Loading from persistent storage
    
    /// Loads data form persisten storage.
    ///
    /// - Parameter handler: A list of servers saved to core data.
    private func loadCached(handler: @escaping (_ servers: [Server]) -> Void) {
        databaseManager.fetch(Server.self) { handler($0) }
    }
    
    // MARK: - Loading from server
    
    /// Loads remote data and saves to persistent store.
    private func loadRemoteAndCache() {
        apiClient.load(Server.get(),
                       success: { [weak self] (servers) in
                        if let servers = servers {
                            self?.databaseManager.save(entities: servers)
                            self?.handleSuccess(with: servers)
                        } else {
                            self?.handleSuccess(with: [])
                        }
            }, failure: { [weak self] (error) in
                self?.handleFailure(with: error)
        })
    }
}
