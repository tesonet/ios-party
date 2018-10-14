//
//  ServiceManager.swift
//  Testio
//
//  Created by Julius on 14/10/2018.
//  Copyright © 2018 jp. All rights reserved.
//

import Alamofire
import PromiseKit

class ServiceManager {
    static let errorDomain = "TestioError"
    fileprivate let headers: HTTPHeaders = ["Accept": "application/json",
                                        "Content-Type": "application/json; charset=utf-8"]
    var sessionManager: SessionManager
    
    public init() {
        sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    }
    
    fileprivate func modifyHeaders(_ headers: inout [String:String], auth: Bool = true) {
        if auth, let token = AuthManager.shared.token {
            headers["Authorization"] = "Bearer " + token
        }
    }
    
    func get(_ url: String, parameters: Parameters?, auth: Bool = true) -> Promise<Data> {
        var requestHeaders = headers
        
        modifyHeaders(&requestHeaders, auth: auth)
        
        return doDataRequest(url, parameters: parameters, headers: requestHeaders)
    }
    
    func post(_ url: String, parameters: Parameters?, auth: Bool = true) -> Promise<Data> {
        var requestHeaders = headers
        
        modifyHeaders(&requestHeaders, auth: auth)
        
        return doDataRequest(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: requestHeaders)
    }
    
    func doDataRequest(_ url: URLConvertible, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> Promise<Data> {
        
        return Promise { seal in
            sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseData { response in
                if response.result.isSuccess {
                    if let value = response.value {
                        seal.fulfill(value)
                    }
                } else {
                    if let statusCode = response.response?.statusCode {
                        let error = NSError(domain: ServiceManager.errorDomain, code: statusCode, userInfo: ["response": response])
                        seal.reject(error)
                    } else {
                        let error = NSError(domain: ServiceManager.errorDomain, code: -1, userInfo: ["response": response])
                        seal.reject(error)
                    }
                }
            }
        }
    }
}
