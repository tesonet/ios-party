//
//  TesonetServerListLoader.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Foundation

class TesonetServerListLoader: ServerListLoader {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 10
        return URLSession(configuration: configuration)
    }()
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: - ServerListLoader
    
    func requestAccessToken(forUser username: String,
                            password: String,
                            completionHandler: @escaping (String?, Error?) -> Void) {
        let requestUrl = URL(string: "http://playground.tesonet.lt/v1/tokens")!
        let bodyDictionary = ["username": username, "password": password]
        let bodyJSONData = try! JSONSerialization.data(withJSONObject: bodyDictionary)
        var request = URLRequest(url: requestUrl,
                                 cachePolicy: session.configuration.requestCachePolicy,
                                 timeoutInterval: session.configuration.timeoutIntervalForRequest)
        request.httpMethod = "POST"
        request.httpBody = bodyJSONData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // todo: get token from data
                    let token: String? = nil // temp
                    completionHandler(token, nil)
                case 401:
                    completionHandler(nil, RequestError.unauthorized)
                default:
                    print("Failed to get access token. HTTP Status: \(httpResponse.statusCode).")
                    completionHandler(nil, RequestError.unknownFailure)
                }
            }
            else {
                completionHandler(nil, RequestError.unknownFailure)
            }
        }
        dataTask.resume()
    }
    
    func fetchServerList(withAccessToken token: String,
                         completionHandler: @escaping ([Server]?, Error?) -> Void) {
        let requestUrl = URL(string: "http://playground.tesonet.lt/v1/servers")!
        var request = URLRequest(url: requestUrl,
                                 cachePolicy: session.configuration.requestCachePolicy,
                                 timeoutInterval: session.configuration.timeoutIntervalForRequest)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // todo: get server list from data
                    let servers: [Server]? = nil // temp
                    completionHandler(servers, nil)
                case 401:
                    completionHandler(nil, RequestError.unauthorized)
                default:
                    print("Failed to get server list. HTTP Status: \(httpResponse.statusCode).")
                    completionHandler(nil, RequestError.unknownFailure)
                }
            }
            else {
                completionHandler(nil, RequestError.unknownFailure)
            }
        }
        dataTask.resume()
    }
}
