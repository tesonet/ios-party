//
//  DataService.swift
//  testio
//
//  Created by Valentinas Mirosnicenko on 11/2/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    
    static let instance = DataService()
    
    private enum LoginStatus: String {
        case token = "token"
        case unauthorized = "Unauthorized"
    }
    
    public private(set) var authToken: String?
    
    public func attemptLogin(username: String, password: String, completion: @escaping (_ success: Bool) -> ()) {
        
        let body:[String:Any] = [
            "username":username,
            "password":password
        ]
        
        Alamofire.request(TesonetAPI.tokensUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: TesonetAPI.header).responseJSON { (response) in
            if response.result.error == nil {
                
                if self.handleLoginResponse(message: response.result.value) == .token {
                    completion(true)
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
            }
        }
        
    }
    
    public func fetchServers(completion: @escaping (_ servers: NSArray?) -> ()) {
        Alamofire.request(TesonetAPI.serversUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TesonetAPI.bearer_header).responseJSON { (response) in
            if response.result.error == nil {
                
                // Check if JSON is a dictionary
                guard let result = response.result.value as? NSArray else {
                    debugPrint("result is not of type NSArray, returning")
                    completion(nil)
                    return
                }
                completion(result)
            }
        }
    }
    
    public func logOut(completion: @escaping (_ done: Bool) -> ()) {
        authToken = nil
        completion(true)
    }
    
    private func handleLoginResponse(message: Any?) -> LoginStatus {
        
        if let json = message as? Dictionary<String,Any> {
            
            if let token = json[LoginStatus.token.rawValue] as? String {
                self.authToken = token
                debugPrint("succesfully saved token value: ",token)
                return .token
            }
            debugPrint("failed to save token value, but got a valid json: ", json)
            return .token
        }
        debugPrint("failed to save token value and got no cigar")
        return .token
        
    }
    
}
