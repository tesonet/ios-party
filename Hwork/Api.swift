//
//  Api.swift
//  Hwork
//
//  Created by Robertas Pauzas on 01/02/2019.
//  Copyright © 2019 Robert P. All rights reserved.
//

import Foundation

final class Api {
    
    static let shared = Api()
    private init() {}
    let session = URLSession.shared
    typealias tokenCompletion   = (_ token: String?, _ error: Const.Response.ErrorStatus?) ->()
    typealias serversCompletion = (_ data: [[String: Any]]?, _ error: Const.Response.ErrorStatus?) ->()

    func requestToken(username:String, password:String, completion: @escaping tokenCompletion ) {
        
        let url = URL(string: Const.Request.auth.url)!
        var request = URLRequest(url: url)
        request.httpMethod = Const.Request.auth.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postDict : [String: Any] = [Const.Request.auth.userNameKey: username, Const.Request.auth.passwordKey: password]
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            completion(nil, Const.Response.ErrorStatus.other)
            return
        }
        request.httpBody = postData
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let errorPresent = self.validateResponse(data: data, response: response, error: error)  {
                DispatchQueue.main.async {
                    completion(nil, errorPresent)
                }
                return
            }
            
            if let tokenData = self.parseToken(data: data!) {
                DispatchQueue.main.async {
                    completion(tokenData, nil)
                }
            }
        }
        task.resume()
    }
    
    func getServerList(token:String, completion: @escaping serversCompletion) {
        
        let url = URL(string: Const.Request.serversList.url)!
        var request = URLRequest(url: url)
        request.httpMethod = Const.Request.serversList.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Const.Request.serversList.headerValuePrefix + token, forHTTPHeaderField: Const.Request.serversList.headerKey)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let errorPresent = self.validateResponse(data: data, response: response, error: error)  {
                DispatchQueue.main.async {
                    completion(nil, errorPresent)
                }
                return
            }
            
            if let servers = self.parseServers(data: data!) {
                DispatchQueue.main.async {
                    completion(servers, nil)
                }
            }
        }
        task.resume()
    }
  
}



private extension Api {
    
    private func validateResponse(data: Data?,response:URLResponse?, error:Error?) -> Const.Response.ErrorStatus? {
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode

        if statusCode == 401 {
            return Const.Response.ErrorStatus.unauthorized
        } else if (error != nil || data == nil) {
            return Const.Response.ErrorStatus.other
        }
        return nil
    }
    
    private func parseToken(data: Data) -> String? {
        
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
            return nil
        }
        if let token = json[Const.Response.auth.tokenKey] as? String {
            return token
        }
        return nil
    }
    
    private func parseServers(data: Data) -> [[String: Any]]? {
        
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [[String: Any]] else {
            return nil
        }
        return json
    }
}
