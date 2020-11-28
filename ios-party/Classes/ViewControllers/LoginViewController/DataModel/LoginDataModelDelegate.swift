//
//  LoginDataModelDelegate.swift
//  ios-party
//
//  Created by Lukas on 11/28/20.
//

import Foundation

protocol LoginDataModelDelegate {
    
    func didStartLoginOperation(dataModel: LoginDataModel)
    func didFinishLoginOperation(dataModel: LoginDataModel)
    func didFailLoginOperation(dataModel: LoginDataModel, message: String)
}
