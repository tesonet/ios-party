//
//  ServerListDataModel.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import Foundation

protocol ServerListDataModelDelegate: AnyObject {
}

protocol ServerListDataModelInterface {
    var serverList: [ServerEntity] { get }
}

class ServerListDataModel: ServerListDataModelInterface {
    
    // MARK: - Declarations
    weak var delegate: ServerListDataModelDelegate?
    var isLoading = false
    
    var serverList: [ServerEntity] = []

    // MARK: - Dependencies
    var serverListRepository: ServerListRepositoryInterface = ServerListRepository.shared
    
    // MARK: - Methods
    init(delegate: ServerListDataModelDelegate) {
        self.delegate = delegate
        serverList = serverListRepository.serverList()
    }
}
