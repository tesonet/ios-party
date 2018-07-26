//
//  APIManager.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation
import Alamofire

let API = APIManager()

typealias LoginClosure = (String?, Error?) -> ()

class APIManager: NSObject {
    
    // MARK: - Enums
    private enum HeaderKey {
        static let acceptLanguage = "Accept-Language"
        static let contentType = "Content-Type"
    }
    
    private enum ParameterKey {
        static let username = "username"
        static let password = "password"
    }
    
    private enum URL {
        static let tokensUrl = "http://playground.tesonet.lt/v1/tokens"
        static let serversUrl = "http://playground.tesonet.lt/v1/servers"
    }
    
    enum ResponseKey {
        static let token = "token"
    }
    
    
    
    // MARK: - Vars

    
    
    // MARK: - Methods
    
    private func makeRequestWith(url: String, method: HTTPMethod, headers: [String : String]? = nil, parameters: [String : String]?) -> DataRequest {
        return Alamofire.request(TodoRouter.makeCustomRequestWith(urlString: url, method: method, headers: headers, parameters: parameters))
    }
    
    func loginWith(username: String, password: String, closure: @escaping LoginClosure) {
        
        // Set parameters
        let parameters: [String : String] = [ParameterKey.username : username, ParameterKey.password : password]
        
        // Make a custom request for Token
        makeRequestWith(url: URL.tokensUrl, method: .post, parameters: parameters).responseJSON { response in
            debugPrint(response.result)
            
            switch response.result {
                case .success(let data):
                    if let responseDict = data as? NSDictionary, let token = responseDict[ResponseKey.token] as? String {
                        closure(token, nil)
                    }
                
                case .failure(let error):
                    closure(nil, error)
            }
        }
    }
    
    
}







