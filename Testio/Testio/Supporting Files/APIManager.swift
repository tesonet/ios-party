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
    
    func getToken(userName: String, password: String, onCompletion:@escaping(String, Int?) -> ())
    {
        let requestParameters = ["username" : userName, "password" : password];
        AF.request(Constants.tokensURL, method: .post, parameters: requestParameters, encoding: JSONEncoding.default).responseJSON {
            response in
            let statusCode = response.response?.statusCode
            switch response.result
            {
            case .success:
                if let value = response.value as? [String : Any]
                {
                    if let token:String = value["token"] as? String
                    {
                        onCompletion(token, statusCode)
                    }
                    else
                    {
                        onCompletion("Error", statusCode)
                    }
                }
                else
                {
                    onCompletion("Error", statusCode)
                }
            case .failure(let error):
                onCompletion(error.localizedDescription, nil)
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
                    CoreDataManager.shared.writeServer(distance: Int16(subJson["distance"].intValue), name: subJson["name"].stringValue)
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
