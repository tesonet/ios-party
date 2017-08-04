//
//  ConnectionManager.swift
//  ios-party
//
//  Created by Ilya Vlasov on 8/4/17.
//  Copyright © 2017 Ilya Vlasov. All rights reserved.
//

import UIKit
import RealmSwift

private let connectionManager = ConnectionManager()

protocol ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject:AnyObject)
}


class ConnectionManager: NSObject {
    class var sharedInstance : ConnectionManager {
        return connectionManager
    }
    var delegate : ConnectionManagerDelegate?
    var token : String = ""
    
    
    let authURL = "http://playground.tesonet.lt/v1/tokens"
    let apiURL = "http://playground.tesonet.lt/v1/servers"
    
    func requestToken() {
        let url = URL(string: authURL)
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        let session = NSURLSession.sharedSession()
        let params : [String:AnyOnbject] = ["username" : "tesonet", "password": "partyanimal"]
        
        request.HTTPMethod = "POST"
        
    
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    self.delegate!.connectionManagerDidRecieveObject(responseObject: json)
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                    self.eroorResponse(jsonStr!)
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                self.eroorResponse(jsonStr!)
            }
        }
        
        task.resume()
        }
    }
    
    func requestServers() {
        let url = URL(string: apiURL)
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization: Bearer")
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    self.delegate!.connectionManagerDidRecieveObject(responseObject: json)
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                    self.eroorResponse(jsonStr!)
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                self.eroorResponse(jsonStr!)
            }
        }
        
        task.resume()
    }

