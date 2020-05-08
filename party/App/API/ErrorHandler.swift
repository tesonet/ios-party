//
//  ErrorHandler.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Moya
import Foundation

final class ErrorHandler: PluginType {
    
    static let instance = ErrorHandler()
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("preparingRequest: ", request.url?.absoluteString ?? "")
        return request
    }

    func willSend(_ request: RequestType, target: TargetType) {
        print("willSendRequest: ", request.request?.url?.absoluteString ?? "")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
        case .failure(let error):
            print("ErrorHandler: statusCode: \(String(describing: error.response?.statusCode))")
            
            guard let code = error.response?.statusCode else { return }
            print("ErrorHandler: \(code)")
            
        case .success(let response):
            
            if response.statusCode == 401 && UIManager.isLoggedIn {
                UIManager.logout()
            }
            
            guard !(200 ... 299 ~= response.statusCode) else { return }
            
            print("ErrorHandler: \(response.data)")
        }
    }
}
