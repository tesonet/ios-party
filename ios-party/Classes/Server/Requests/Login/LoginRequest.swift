//
//  LoginRequest.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-23.
//

import Foundation
import Alamofire

class LoginRequest {
    
    // MARK: - Constants
    private let kLoginRequestURLString = "https://playground.tesonet.lt/v1/tokens"
    private let kLoginURLParameterKey = "username"
    private let kPasswordURLParameterKey = "password"
    private let kTokenKeyInJSONResponse = "token"
    
    // MARK: - Declarations
    private (set) var input: LoginInput
    private (set) var output = LoginOutput()
    var completionHandler: (() -> Void)?
    
    // MARK: - Methods
    init(withInput input: LoginInput) {
        self.input = input
    }
    
    func start() {
        var parameterDict: [String: String] = [:]
        parameterDict[kLoginURLParameterKey] = input.username
        parameterDict[kPasswordURLParameterKey] = input.password
        
        let request: DataRequest = AF.request(kLoginRequestURLString,
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
    
    private func didFinishLoginRequest(responseData: Any) {
        guard let responseDict = responseData as? [String: Any] else {
            log("ERROR! Could not parse response dictionary from response data: \(responseData)")
            completionHandler?()
            return
        }
        
        guard let token = responseDict[kTokenKeyInJSONResponse] as? String else {
            log("ERROR! Could not parse token from response dictionary: \(responseDict)")
            completionHandler?()
            return
        }
        
        output.isSuccessful = true
        output.token = token
        
        completionHandler?()
    }
    
    private func didFailLoginRequest(error: AFError) {
        output.error = error
        
        completionHandler?()
    }
}
