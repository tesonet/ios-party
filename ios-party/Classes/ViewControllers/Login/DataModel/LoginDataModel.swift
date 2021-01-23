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
        
        var parameterDict: [String: String] = [:]
        parameterDict["username"] = username
        parameterDict["password"] = password
        
        let request: DataRequest = AF.request("https://playground.tesonet.lt/v1/tokens",
                                              method: .post,
                                              parameters: parameterDict,
                                              encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
        
        request.responseJSON(completionHandler: { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.didFinishLoginRequest(responseData: data)
                
            case .failure(let error):
                self?.didFailLoginRequest(error: error)
            }
        })
    }
    
    func didFinishLoginRequest(responseData: Any) {
        isLoading = false
        
        guard let responseDict = responseData as? [String: Any] else {
            log("ERROR! Could not parse response dictionary from response data: \(responseData)")
            delegate?.loginDataModel(didFailLogin: self)
            return
        }
        
        guard let token = responseDict["token"] as? String else {
            log("ERROR! Could not parse token from response dictionary: \(responseDict)")
            delegate?.loginDataModel(didFailLogin: self)
            return
        }
        
        authorization.setToken(token: token)
        delegate?.loginDataModel(didFinishLogin: self)
    }
    
    func didFailLoginRequest(error: AFError) {
        isLoading = false
        
        if error.responseCode == 401 {
            log("ERROR! Login failed with code 401")
            delegate?.loginDataModel(didFailLogin: self)
        } else {
            log("Login request failed with error: \(error)")
            delegate?.loginDataModel(didFailLogin: self)
        }
    }
    
    func parseAccessToken(responseData: Any) -> String? {
        guard let responseData = responseData as? [String: Any],
              let token = responseData["token"] as? String else {
            return nil
        }
        
        return token
    }
}
