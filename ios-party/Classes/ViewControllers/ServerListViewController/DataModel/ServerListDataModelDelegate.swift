//
//  ServerListDataModelDelegate.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation

protocol ServerListDataModelDelegate {
    
    func didStartServerListLoadOperation(dataModel: ServerListDataModel)
    func didFinishServerListLoadOperation(dataModel: ServerListDataModel)
    func didFailServerListLoadOperation(dataModel: ServerListDataModel)
    
    func didUpdateServerListBySort(dataModel: ServerListDataModel)
}
