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
    static let shared = APIManager()
    
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
            case .failure(let error):
                print(error.localizedDescription)
                onCompletion(false, "Error", nil)
            }
        }
    }
    
    func isConnectedToInternet() -> Bool
    {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func getServers(token: String, onCompletion:@escaping(Bool, [Server]?) -> ())
    {
        //check if internet is available, if not - load servers from database
        if (!self.isConnectedToInternet())
        {
            let servers = CoreDataManager.shared.getServers(sortDescriptor: nil)
            onCompletion(true, servers)
            return
        }
        let header:HTTPHeaders = ["Authorization" : "Bearer \(token)"]
        AF.request(Constants.serversURL, headers: header).responseJSON{
            response in
            
            switch response.result
            {
            case .success:
                let responseJSON:JSON = JSON(response.value!)
                CoreDataManager.shared.deleteServers()
                for (_, subJson) : (String, JSON) in responseJSON
                {
                    CoreDataManager.shared.writeServers(distance: Int16(subJson["distance"].intValue), name: subJson["name"].stringValue)
                    print(subJson["name"].stringValue)
                }
                CoreDataManager.shared.saveContext()
                let servers = CoreDataManager.shared.getServers(sortDescriptor: nil)
                onCompletion(true, servers)
            case .failure(let error):
                print(error.localizedDescription)
                onCompletion(false, nil)
            }
            
        }
    }
}
