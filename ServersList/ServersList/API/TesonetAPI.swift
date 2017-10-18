//
//  TesonetAPI.swift
//  ServersList
//
//  Created by Tomas Stasiulionis on 17/10/2017.
//  Copyright © 2017 Tomas Stasiulionis. All rights reserved.
//

import Foundation

protocol TesonetAPIDelegate {
    func authenticated(success: Bool);
}

class TesonetAPI: API {
    
    var delegate : TesonetAPIDelegate?
    
    let authUrl : String = "http://playground.tesonet.lt/v1/tokens";
    var authToken : String = "";
    
    //Singleton approach
    static let sharedInstance = TesonetAPI()
    
    func authenticate(username:String, password:String) {
        self.makeRequest(method: "POST", url:self.authUrl, parameters: ["username":username, "password":password]).responseJSON { (response)  in
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                if(self.checkIfAuthenticated(result: JSON)){
                    self.delegate?.authenticated(success: true)
                    return
                }
            }
            self.delegate?.authenticated(success: false)
        }
    }
    
    func checkIfAuthenticated(result : NSDictionary) -> Bool {
        if(result.object(forKey: "token") != nil){
            return true
        }
        
        return false
    }
    
}
