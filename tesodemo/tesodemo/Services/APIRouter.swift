//
//  APIRouter.swift
//  tesodemo
//
//  Created by Vytautas Vasiliauskas on 16/07/2017.
//
//

import Foundation

enum APIRouter {
    static let baseUrl = URL(string: "http://playground.tesonet.lt/v1/")!
    static let timeout:TimeInterval = 30
    
    case Login(String, String)
    case RetrieveServers()

    
    var method: String {
        switch self {
        case .Login:
            return "POST"
        default:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .Login:
            return "tokens"
        case .RetrieveServers:
            return "servers"
        }
    }
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: APIRouter.baseUrl.appendingPathComponent(path))
        
        request.timeoutInterval = APIRouter.timeout
        
        request.httpMethod = method
        
        if let token = SessionManager.sharedInstance.token {
            request.setValue(String(format: "Bearer %@", token), forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .Login(let username, let password):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let payload = ["username": username, "password": password]
            do {
                let json = try JSONSerialization.data(withJSONObject: payload, options: [])
                request.httpBody = json
            }
            catch {
                
            }
            return request
        default:
            return request
        }
    }

}
