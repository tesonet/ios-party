//
//  ConnectionManager.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit
import Realm
import KeychainSwift
import ObjectMapper

private let connectionManager = ConnectionManager()

protocol ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject:Any)
}


class ConnectionManager: NSObject {
    class var sharedInstance : ConnectionManager {
        return connectionManager
    }
    var delegate : ConnectionManagerDelegate?
    var token : String = ""
    
    
    let authURL = "http://playground.tesonet.lt/v1/tokens"
    let apiURL = "http://playground.tesonet.lt/v1/servers"
    
    
    func requestToken(withParams params:[String:Any]) {
        let url = URL(string: authURL)
        let request = NSMutableURLRequest.init(url:url!)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else {
//                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    let token = json.object(forKey: "token") as! String
                    Utilities.sharedInstance.keychain.set(token, forKey: "token")
                    
                    self.delegate!.connectionManagerDidRecieveObject(responseObject: json)
                } else {
//                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
//                    print("Error could not parse JSON: \(jsonStr)")
//                    self.eroorResponse(jsonStr!)
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
//                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("Error could not parse JSON: '\(jsonStr)'")
//                self.eroorResponse(jsonStr!)
            }
        }
        
        task.resume()
    }
    
    func requestServers() {
        let url = URL(string: self.apiURL)
        let request = NSMutableURLRequest.init(url:url!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        if let token = Utilities.sharedInstance.keychain.get("token") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else {
//                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [[String:Any]] {
                    print("Response: \(json)")
                    DataManager.sharedInstance.sync(servers: Array(Mapper<Server>().mapSet(JSONArray: json)))
                } else {
//                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
//                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
//                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()
    }
}

 

