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
    private(set) var serverList: [ServerListEntity] = []
    
    // MARK: - Dependencies
    private let operation = ServerListOperation()
    
    // MARK: - Methods
    init(delegate: ServerListDataModelDelegate) {
        self.delegate = delegate
        
        loadServers()
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
    
    private func didFinishServerLoad(data: Any) {
        // FIXME: check for thread!
        guard let dictList = data as? [[String: Any]] else {
            delegate?.didFailServerListLoadOperation(dataModel: self)
            print("could not found server dictionary")
            return
        }
        
        serverList = ServerListEntity.listFrom(dictList: dictList)
        
        delegate?.didFinishServerListLoadOperation(dataModel: self)
    }
    
    private func didFailServerLoad(error: AFError) {
        print("fail to load servers!")
        delegate?.didFailServerListLoadOperation(dataModel: self)
    }
    
}
