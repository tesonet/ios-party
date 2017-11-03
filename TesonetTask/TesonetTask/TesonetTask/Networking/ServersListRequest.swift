//
//  ServersListRequest.swift
//  TesonetTask
//
//  Created by abelenkov on 10/9/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

class ServersListRequest: NSObject {
    private static let serversPath : String = "servers"
    
    class func getServersList(token:String, completion:@escaping NetworkingManager.kRequestCompletion) -> URLSessionTask {
        let session = URLSession.shared
        
        var request : URLRequest = URLRequest(url: URL(string: NetworkingManager.kBaseURLString + serversPath)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTask(with: request) { (outData, outResponse, outError) in
            completion(outData, outResponse, outError)
        }
        dataTask.resume()
        return dataTask
    }
}
