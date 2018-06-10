//
//  APIClient.swift
//  Servers
//
//  Created by Rimantas Lukosevicius on 10/06/2018.
//  Copyright © 2018 Rimantas Lukosevicius. All rights reserved.
//

import UIKit

struct TokenRequest : Encodable {
    var username : String;
    var password : String;
}

class APIClient: NSObject {
    private var token : String?
    
    static let shared : APIClient = APIClient()
    
    func obtainTokenWith(username:String, password:String, completion: @escaping (_ success: Bool) -> Void) {
        let request = TokenRequest(username: username, password: password)
        
        let jsonEncoder = JSONEncoder()
        let requestJSON = try! jsonEncoder.encode(request)
        
        var httpRequest = URLRequest.init(url: URL(string: "http://playground.tesonet.lt/v1/tokens")!)
        httpRequest.httpMethod = "POST"
        httpRequest.httpBody = requestJSON
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =
        URLSession.shared.dataTask(with: httpRequest) { (respData, resp, err) in
            guard err == nil else {
                completion(false)
                return
            }
            
            guard resp != nil else {
                completion(false)
                return
            }
            
            guard respData != nil else {
                completion(false)
                return
            }
            
            if let respData = respData {
                guard let respDict = try? JSONSerialization.jsonObject(with: respData, options: []) as? Dictionary<String, String> else {
                    completion(false)
                    return
                }
                
                guard let token = respDict?["token"] else {
                    completion(false)
                    return
                }
                
                self.token = token
                completion(true)
            }
        }
        
        task.resume()
    }
    
}
