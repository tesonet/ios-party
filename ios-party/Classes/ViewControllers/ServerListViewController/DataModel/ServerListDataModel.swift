//
//  ServerListDataModel.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation
import Alamofire

class ServerListDataModel {
    
    // MARK: - Declarations
    private let delegate: ServerListDataModelDelegate?
    
    private(set) var originalServerList: [ServerListEntity] = []
    private(set) var sortedServerList: [ServerListEntity] = []
    
    var sortType: serverListSortType = .notSorted
    
    // MARK: - Dependencies
    private let operation = ServerListOperation()
    private let serverListRepository = ServerListRepository.shared
    
    // MARK: - Methods
    init(delegate: ServerListDataModelDelegate) {
        self.delegate = delegate
        
        loadServers()
    }
    
    func serverList() -> [ServerListEntity] {
        if sortType == .notSorted {
            return originalServerList
        } else {
            return sortedServerList
        }
    }
    
    func loadServers() {
        delegate?.didStartServerListLoadOperation(dataModel: self)
        
        let request = operation.request()
        request?.responseJSON { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.didFinishServerLoad(data: data)
            case .failure(let error):
                self?.didFailServerLoad(error: error)
            }
        }
    }
    
    func set(sortType: serverListSortType) {
        self.sortType = sortType
        
        sortServerList()
    }
    
    // MARK: - Helpers
    private func didFinishServerLoad(data: Any) {
        guard let serverList = operation.parseServerList(response: data) else {
            delegate?.didFailServerListLoadOperation(dataModel: self)
            print("could not parse response data!")
            return
        }
        
        storeServerList(serverList)
        delegate?.didFinishServerListLoadOperation(dataModel: self)
    }
    
    private func didFailServerLoad(error: AFError) {
        print("fail to load server list!")
        delegate?.didFailServerListLoadOperation(dataModel: self)
    }
    
    private func storeServerList(_ serverList: [ServerListEntity]) {
        self.originalServerList = serverList
        self.sortedServerList = ServerListEntity.serverList(serverList, sortedBy: sortType)
        
        serverListRepository.setServerList(serverList)
    }
    
    private func sortServerList() {
        self.sortedServerList = ServerListEntity.serverList(originalServerList, sortedBy: sortType)
        delegate?.didUpdateServerListBySort(dataModel: self)
    }
}
