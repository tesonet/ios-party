//
//  ServerListDataModel.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

protocol ServerListDataModelDelegate: class {
    func serverListDataModelDidLoad(_ dataModel: ServerListDataModel)
    func serverListDataModel(_ dataModel: ServerListDataModel, didFailWithError error: Error)
}

class ServerListDataModel {
    
    // MARK: - Dependencies
    
    let apiClient: ApiClient
    
    // MARK: - States
    
    var data: [ServerCellViewModel] = []
    
    weak var delegate: ServerListDataModelDelegate?
    
    private(set) var isLoading: Bool = false
    
    // MARK: - Init
    
    init(delegate: ServerListDataModelDelegate, apiClient: ApiClient) {
        self.delegate = delegate
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    func loadData() {
        guard isLoading == false else {
            return
        }
        isLoading = true
        
        apiClient.load(Server.get(),
                       success: { [weak self] (servers) in
                        self?.handleSuccess(with: servers)
            }, failure: { [weak self] (error) in
                self?.handleFailure(with: error)
        })
    }
    
    // MARK: - Private Methods
    
    private func handleFailure(with error: Error) {
        isLoading = false
        delegate?.serverListDataModel(self, didFailWithError: error)
    }
    
    private func handleSuccess(with data: [Server]?) {
        isLoading = false
        self.data = data?.map { ServerCellViewModel(server: $0) } ?? []
        delegate?.serverListDataModelDidLoad(self)
    }
}
