//
//  LoginRequest.swift
//  TesonetTask
//
//  Created by abelenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class LoginRequest {
    
    private static let tokenPath : String = "tokens"
    
    class func login(username:String, password:String, completion:@escaping NetworkingManager.kRequestCompletion) -> URLSessionTask {
        let session = URLSession.shared
        
        var request : URLRequest = URLRequest(url: URL(string: NetworkingManager.kBaseURLString + tokenPath)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        let body = ["username":username, "password":password]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        let dataTask = session.dataTask(with: request) { (outData, outResponse, outError) in
            completion(outData, outResponse, outError)
        }
        dataTask.resume()
        return dataTask
    }
    
}
