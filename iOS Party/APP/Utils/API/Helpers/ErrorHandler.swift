//
//  ErrorHandler.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Foundation
import Result
import Moya
import Unbox

final class ErrorHandler: PluginType {
    
    static let instance = ErrorHandler()
    
    public func didReceive(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) {
        switch result {
        case .failure(let error):
            //Here we can debug network related bugs
            print("statusCode: ", error.response?.statusCode ?? "UNKNONW")
            //Or show network errors.
        case .success(let response):
            
            guard !(200 ... 299 ~= response.statusCode) else { return }
            
            //If status code is not between 200 and 299, it's an error. 
            //In real project I could parse an error and show it like this:
//            AppDelegate.catchError(response.data)
            //In this case I am simply showing error
            AppDelegate.showAlert(message: "Error")
        }
    }
}
