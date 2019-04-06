//
//  ErrorHandler.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import Result
import Moya

final class ErrorHandler: PluginType {
    
    static let instance = ErrorHandler()
    
    func willSend(_ request: RequestType, target: TargetType) {
        print("willSendRequest: ", request.request?.url?.absoluteString ?? "unkonwn url")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .failure(let error):
            print("didReceive error: ", error)
            //TODO: - Show error alert
            
        case .success(let response):
            
            if response.statusCode == 401 {
                LoginService.logOutUser()
            }
            
            guard !(200 ... 299 ~= response.statusCode) else { return }
            //TODO: - Show error alert
        }
    }
}
