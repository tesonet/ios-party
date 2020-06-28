//
//  APIManager.swift
//  Testio
//
//  Created by Ernestas Šeputis on 6/28/20.
//  Copyright © 2020 Ernestas Šeputis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class APIManager
{
    
    func getToken(userName: String, password: String, onCompletion:@escaping(Bool, String, Int?) -> ())
    {
        let requestParameters = ["username" : userName, "password" : password];
        AF.request(Constants.tokensURL, method: .post, parameters: requestParameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result
            {
            case .success:
                if let value = response.value as? [String : Any]
                {
                    if response.response?.statusCode == 401
                    {
                        onCompletion(false, value["message"] as! String, 401)
                    }
                    else if response.response?.statusCode == 200
                    {
                        let token:String = value["token"] as! String
                        onCompletion(true, token, nil)
                    }
                }
                else
                {
                    onCompletion(false, "Error", response.response?.statusCode)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                onCompletion(false, "Error", nil)
            }
        }
    }
    
    func getServers(token: String, onCompletion:@escaping(Bool, [Server]?) -> ())
    {
        let header:HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(Constants.serversURL, headers: header).responseJSON{
            response in
            switch response.result
            {
            case .success:
                let responseJSON:JSON = JSON(response.value!)
                for (_, subJson) : (String, JSON) in responseJSON
                {
                    CoreDataManager.shared.writeServers(distance: Int16(subJson["distance"].intValue), name: subJson["name"].stringValue)
                    print(subJson["name"].stringValue)
                }
                let servers = CoreDataManager.shared.getServers()
                onCompletion(true, servers)
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                onCompletion(false, nil)
            }
            
        }
    }
}
