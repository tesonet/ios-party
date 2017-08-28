//
//  Networking.swift
//  ios-party
//
//  Created by Adomas on 27/08/2017.
//  Copyright © 2017 Adomas. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class Request {
    
    private let baseURL = "http://playground.tesonet.lt/v1/"
    
    func dataTask(withPath path: String, method: HTTPMethod = .get, body: [String:Any] = [:], tokenRequired: Bool = true, completion: @escaping (NSObject?, Error?) -> Void) {
        guard let request = setupRequest(path: path, method: method, body: body, tokenRequired: tokenRequired) else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        
        performTask(withRequest: request, completion: completion)
    }
    
    private func setupRequest(path: String, method: HTTPMethod, body: [String:Any], tokenRequired: Bool) -> URLRequest? {
        guard let url = URL(string: baseURL + path) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if tokenRequired {
            if let token = UserDefaults.standard.string(forKey: Keys.tokenKey) {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            } else {
                return nil
            }
        }
        
        if body.count > 0 {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            } catch {
                return nil
            }
        }
        
        return request
    }
    
    private func performTask(withRequest request: URLRequest, completion: @escaping (NSObject?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            var object: NSObject? = nil
            if error == nil {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSObject {
                            object = json
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                completion(object, error)
            }
        })
        
        dataTask.resume()
    }
}
