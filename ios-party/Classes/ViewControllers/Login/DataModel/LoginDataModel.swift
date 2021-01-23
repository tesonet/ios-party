//
//  LoginDataModel.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import Alamofire

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
    var isLoading = false

    // MARK: - Dependencies
    var authorization: AuthorizationInterface = Authorization.shared
    
    // MARK: - Methods
    init(delegate: LoginDataModelDelegate) {
        self.delegate = delegate
    }
    
    func login(withUsername username: String, password: String) {
        guard !isLoading else {
            log("ERROR! Login is already in progress.")
            return
        }
        
        isLoading = true
        delegate?.loginDataModel(didStartLogin: self)
        
        startLoginRequest(username: username, password: password)
    }
    
    func startLoginRequest(username: String, password: String) {
        let input = LoginInput(username: username, password: password)
        let request = LoginRequest(withInput: input)
        request.completionHandler = { [weak self] in
            self?.didFinishLoginRequest(request)
        }
        
        request.start()
    }
    
    func didFinishLoginRequest(_ request: LoginRequest) {
        isLoading = false
        
        guard request.output.isSuccessful,
              let token: String = request.output.token else {
            didFailLoginRequest(error: request.output.error)
            return
        }
        
        authorization.setToken(token: token)
        delegate?.loginDataModel(didFinishLogin: self)
    }
    
    func didFailLoginRequest(error: AFError?) {
        guard let error: AFError = error else {
            log("ERROR Login failed without error.")
            delegate?.loginDataModel(didFailLogin: self)
            return
        }
        
        if error.responseCode == 401 {
            log("ERROR! Login failed with code 401")
            delegate?.loginDataModel(didFailLogin: self)
        } else {
            log("Login request failed with error: \(error)")
            delegate?.loginDataModel(didFailLogin: self)
        }
    }
}
