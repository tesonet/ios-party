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
    
    func getToken(userName: String, password: String){
        let parameters : [String : String] = ["username" : userName, "password" : password]
        Alamofire.request(Constants.TOKENS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if response.result.isSuccess{
                print("Success")
                let token = ResponseParser.parseToken(json: JSON(response.result.value!))
                print(token)
            }else{
                print("Error")
            }
        }
    }
}
