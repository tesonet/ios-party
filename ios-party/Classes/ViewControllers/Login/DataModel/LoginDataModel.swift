//
//  LoginDataModel.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation

protocol LoginDataModelDelegate: AnyObject {
    func loginDataModel(didStartLogin dataModel: LoginDataModelInterface)
    func loginDataModel(didFinishLogin dataModel: LoginDataModelInterface)
    func loginDataModel(didFailLogin dataModel: LoginDataModelInterface)
}

protocol LoginDataModelInterface {
    func login(withUsername username: String, password: String)
}

class LoginDataModel: LoginDataModelInterface {
    
    // MARK: - Declarations
    weak var delegate: LoginDataModelDelegate?
    var operationQueue = OperationQueue()
    var isLoading = false

    // MARK: - Dependencies
    // FIXME: add authorization client
    
    // MARK: - Methods
    init(delegate: LoginDataModelDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        operationQueue.cancelAllOperations()
    }
    
    func login(withUsername username: String, password: String) {
        guard !isLoading else {
            log("ERROR! Login is already in progress.")
            return
        }
        
        isLoading = true
        delegate?.loginDataModel(didStartLogin: self)
        
        // FIXME: implement login operation
        let operation = Operation()
        
        operationQueue.addOperation(operation)
    }
}
