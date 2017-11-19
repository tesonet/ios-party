//
//  API.swift
//  testio
//
//  Created by Karolis Misiūra on 18/11/2017.
//  Copyright © 2017 Karolis Misiura. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unauthorized
    case mallformedResponse
}

class API {
    
    public static func login(username: String, password: String, completion: @escaping (_ error: Error?, _ token: String?) -> Swift.Void) {
        let parameters = ["username": username, "password": password]
        let url = URL(string: "http://playground.tesonet.lt/v1/tokens")!
        API.post(jsonParams: parameters, url: url, completionHandler: { (data, response, error) in
            
            let status = (response as? HTTPURLResponse)?.statusCode
            
            if status == 401 {
                DispatchQueue.main.async {
                    completion(APIError.unauthorized, nil)
                }
            } else if status != 200 {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(error, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(APIError.mallformedResponse, nil)
                    }
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(APIError.mallformedResponse, nil)
                }
                return
            }
            
            guard let responseDic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(APIError.mallformedResponse, nil)
                }
                return
            }
            
            guard let token = responseDic["token"] as? String else {
                DispatchQueue.main.async {
                    completion(APIError.mallformedResponse, nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil, token)
            }
        })
    }
    
    public static func serverList(access token: String, completion: @escaping (_ error: Error?, _ serverList: [[String: Any]]?) -> Swift.Void) {
        let session = URLSession.shared
        let url = URL(string: "http://playground.tesonet.lt/v1/servers")!
        let request = NSMutableURLRequest(url: url)
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            let status = (response as? HTTPURLResponse)?.statusCode
            
            if status == 401 {
                DispatchQueue.main.async {
                    completion(APIError.unauthorized, nil)
                }
            } else if status != 200 {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(error, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(APIError.mallformedResponse, nil)
                    }
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(APIError.mallformedResponse, nil)
                }
                return
            }
            
            guard let responseDic = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                DispatchQueue.main.async {
                    completion(APIError.mallformedResponse, nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil, responseDic)
            }
        })
        
        task.resume()
    }
    
    private static func post(jsonParams: [String: String], url : URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let request = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonParams, options: [])
            request.httpBody = data
        } catch {
            fatalError("Failed to convert json parameters to json data with error \(String(describing: error))")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        
        task.resume()
    }
}
