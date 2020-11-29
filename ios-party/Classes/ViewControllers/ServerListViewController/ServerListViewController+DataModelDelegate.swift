//
//  ServerListViewController+Delegate.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation

extension ServerListViewController: ServerListDataModelDelegate {

    func didStartServerListLoadOperation(dataModel: ServerListDataModel) {
        
    }
    
    func didFinishServerListLoadOperation(dataModel: ServerListDataModel) {
        tableView.reloadData()
    }
    
    func didFailServerListLoadOperation(dataModel: ServerListDataModel) {
        
    }
}
