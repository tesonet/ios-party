//
//  ServerListDataModel.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation
import Alamofire

class ServerListDataModel {
    
    private let operation = ServerListOperation()
    
    func loadServers() {
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
        
    }
    
    private func didFailServerLoad(error: AFError) {
        
    }
    
}
