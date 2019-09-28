//
//  APIHandler.swift
//  iosparty
//
//  Created by Mantas Skeiverys on 28/09/2019.
//  Copyright © 2019 Mantas Skeiverys. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class APIHandler{
    
    func getToken(userName: String, password: String, onComplete: @escaping (AuthorizationResponse) -> ()){
        let parameters : [String : String] = ["username" : userName, "password" : password]
        Alamofire.request(Constants.TOKENS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if response.result.isSuccess{
                if ResponseParser.isAuthorized(json: JSON(response.result.value!)){
                    let token = ResponseParser.parseToken(json: JSON(response.result.value!))
                    onComplete(AuthorizationResponse(success: true, token: token))
                    return
                }
            }
            onComplete(AuthorizationResponse(success: false, token: ""))
        }
    }
    
    func getServers(token: String, onComplete: @escaping ([Server]) -> ()){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        Alamofire.request(Constants.SERVERS_URL, headers: headers).responseJSON { response in
            let servers = ResponseParser.parseServers(json: JSON(response.result.value!))
            onComplete(servers)
        }
    }
}


