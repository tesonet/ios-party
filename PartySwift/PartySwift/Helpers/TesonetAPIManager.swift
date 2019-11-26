//
//  TesonetAPIManager.swift
//  PartySwift
//
//  Created by Arturas Kuciauskas on 23.11.2019.
//  Copyright © 2019 Party. All rights reserved.
//

import UIKit
import Alamofire

class TesonetAPIManager: NSObject
{
    static let shared = TesonetAPIManager()
    
    var token: String?
    
    
    func loginWithCredentials(username:String, password:String, completion: @escaping (AFDataResponse<Any>) -> Void)
    {
      guard let authLoginUrl = URL(string: "http://playground.tesonet.lt/v1/tokens") else
      {
        return
      }
      
      let params: Parameters =
      [
          "username": "\(username)",
          "password": "\(password)"
      ]

      AF.request(authLoginUrl,
                 method: .post,
                 parameters: params,
                 encoding: URLEncoding.default,
                 headers: nil,
                 interceptor: nil)
      
          .validate(contentType: ["application/json"])
          .responseJSON { response in
            
            completion (response)
      }
    }
    
    func fetchServersList(completion: @escaping ( Result<[Server], AFError>)->Void)
    {
        guard let requestUrl = URL(string: "http://playground.tesonet.lt/v1/servers") else
        {
          return
        }
        
        let headers: HTTPHeaders =
        [
            "Authorization": "Bearer \(self.token!)",
            "Accept": "application/json"
        ]
        
        let jsonDecoder = JSONDecoder()
        
        AF.request(requestUrl,
                   method: .get,
                   headers: headers)
            .responseDecodable (decoder: jsonDecoder){ (response: AFDataResponse<[Server]>) in
                 completion(response.result)
               
        }
    }
    

}
