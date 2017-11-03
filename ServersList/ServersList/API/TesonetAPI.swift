//
//  TesonetAPI.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 17/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol TesonetAPIDelegate {
    @objc optional func authenticated(success: Bool);
    @objc optional func downloadedInfo(info: NSArray);
}

class TesonetAPI: API {
    
    var delegate : TesonetAPIDelegate?
    
    let authUrl : String = "http://playground.tesonet.lt/v1/tokens"
    let serversUrl : String = "http://playground.tesonet.lt/v1/servers"
    var authToken : String = ""
    
    //Singleton approach
    static let sharedInstance = TesonetAPI()
    
    /*
     * Authenticates to API and calls TesonetAPIDelegate authenticated() method
     * @param username - user name
     * @param password - user password
     */
    func authenticate(username:String, password:String) {
        self.makeRequest(method: "POST", url:self.authUrl, parameters: ["username":username, "password":password]).responseJSON { (response)  in
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                if(self.checkIfAuthenticated(result: JSON)){
                    self.authToken = JSON .object(forKey: "token") as! String
                    self.delegate?.authenticated!(success: true)
                    return
                }
            }
            self.delegate?.authenticated!(success: false)
        }
    }
    
    /*
     * Gets servers list from API and calls TesonetAPIDelegate downloadedInfo() method
     */
    func getServers(){
        if(self.authToken != ""){
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + self.authToken
            ]
            
            self.makeRequest(method: "GET", url:self.serversUrl, parameters: [:], headers: headers).responseJSON { (response)  in
                if let result = response.result.value {
                    let JSON = result as! NSArray
                    self.delegate?.downloadedInfo!(info: JSON)
                }
            }
        }
    }
    
    /**
     * Checks if EndPoint received "token"
     * @param result - received result
     * @return bool
     */
    func checkIfAuthenticated(result : NSDictionary) -> Bool {
        if(result.object(forKey: "token") != nil){
            return true
        }
        
        return false
    }
    
    /**
     * Cleans token on logout.
     */
    func cleanAuthorizationToken(){
        self.authToken = ""
    }
    
}
