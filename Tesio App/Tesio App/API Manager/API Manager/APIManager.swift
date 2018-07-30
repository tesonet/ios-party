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

typealias LoginClosure = (_ servers: [Server]?, _ error: TesioHelper.LoginError?) -> ()
typealias TokenClosure = (_ error: TesioHelper.LoginError?) -> ()

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
    
    private func makeRequestWith(url: String, method: HTTPMethod, headers: [String : String]? = nil, parameters: [String : String]? = nil) -> DataRequest {
        return Alamofire.request(APIRouter.makeCustomRequestWith(urlString: url, method: method, headers: headers, parameters: parameters))
    }
    
    func loginWith(username: String, password: String, closure: @escaping LoginClosure) {
        getAccessTokenFor(username: username, password: password) { tokenError in
            guard let tokenError = tokenError else {
                self.getServersList(closure: { (servers, serversError) in
                    guard let serversError = serversError else {
                        closure(servers, nil)
                        return
                    }
                    closure(nil, serversError)
                })
                return
            }
            closure(nil, tokenError)
        }
    }
    
    func getAccessTokenFor(username: String, password: String, closure: @escaping TokenClosure) {
        // Set parameters
        let parameters: [String : String] = [ParameterKey.username : username, ParameterKey.password : password]
        
        // Make a custom request for Token
        makeRequestWith(url: URL.tokensUrl, method: .post, parameters: parameters).responseJSON { response in
            //debugPrint(response.result)
            
            switch response.result {
                case .success:
                    if let jsonData = response.data {
                        do {
                            let token = try JSONDecoder().decode(Token.self, from: jsonData)
                            token.encode()
                            closure(nil)
                        } catch {
                            debugPrint("Failed with error: \(error.localizedDescription)")
                            if response.response?.statusCode == 401 {
                                closure(TesioHelper.LoginError.AuthorizationFailed)
                            }
                            else {
                                closure(TesioHelper.LoginError.Other)
                            }
                        }
                    }
                    else {
                        closure(nil)
                    }
                
                case .failure(let error):
                    debugPrint("Access token request failed with error: \(error.localizedDescription)")
                    closure(TesioHelper.LoginError.Other)
            }
        }
    }
    
    func getServersList(closure: @escaping LoginClosure) {
        // Make a custom request for Servers
        makeRequestWith(url: URL.serversUrl, method: .get).responseJSON { response in
            debugPrint(response.result)
            
            switch response.result {
                case .success:
                    if let jsonData = response.data {
                        do {
                            let serversList = try JSONDecoder().decode([Server].self, from: jsonData)
                            TesioHelper.saveServers(serversList)
                            closure(serversList, nil)
                        } catch {
                            debugPrint("Failed with error: \(error.localizedDescription)")
                            closure(nil, TesioHelper.LoginError.Other)
                        }
                    }
                    else {
                        closure(nil, TesioHelper.LoginError.Other)
                    }
                
                case .failure(let error):
                    debugPrint("Servers request failed with error: \(error.localizedDescription)")
                    closure(nil, TesioHelper.LoginError.Other)
            }
        }
    }
    
    
}







