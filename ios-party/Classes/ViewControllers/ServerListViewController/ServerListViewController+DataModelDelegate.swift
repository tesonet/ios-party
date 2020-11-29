//
//  ServerListViewController+Delegate.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation

extension ServerListViewController: ServerListDataModelDelegate {

    func didStartServerListLoadOperation(dataModel: ServerListDataModel) {
        showLoading()
    }
    
    func didFinishServerListLoadOperation(dataModel: ServerListDataModel) {
        hideLoading()
        
        tableView.reloadData()
    }
    
    func didFailServerListLoadOperation(dataModel: ServerListDataModel) {
        hideLoading()
        
        let warning = AlertControllerFactory.showGenericAlert()
        present(warning, animated: true)
    }
}
