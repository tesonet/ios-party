//
//  TesonetServerListLoader.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Foundation

class TesonetServerListLoader: ServerListLoader {
    private var activeSession: URLSession?
    private var session: URLSession {
        if activeSession == nil {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.timeoutIntervalForRequest = 10
            activeSession = URLSession(configuration: configuration)
        }
        return activeSession!
    }

    deinit {
        abortAllLoadingTasks()
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
                    guard let receivedData = data else {
                        print("Failed to get access token. " +
                            "HTTP Status is 200, but no data was received.")
                        assert(false)
                        completionHandler(nil, RequestError.unknownFailure)
                        break
                    }
                    
                    let jsonObj = try? JSONSerialization.jsonObject(with: receivedData, options: [])
                    let dataDictionary = jsonObj as? [String: String]
                    if let token = dataDictionary?["token"] {
                        completionHandler(token, nil)
                    }
                    else {
                        print("Failed to get access token from received data.")
                        assert(false)
                        completionHandler(nil, RequestError.unknownFailure)
                    }
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
                    guard let receivedData = data else {
                        print("Failed to fetch server list. " +
                            "HTTP Status is 200, but no data was received.")
                        assert(false)
                        completionHandler(nil, RequestError.unknownFailure)
                        break
                    }
                    
                    let jsonObj = try? JSONSerialization.jsonObject(with: receivedData, options: [])
                    if let serverDictionariesArray = jsonObj as? [[String: Any]] {
                        var serverList = [Server]()
                        for serverDictionary in serverDictionariesArray {
                            if let server = Server(jsonDictionary: serverDictionary) {
                                serverList.append(server)
                            }
                            else {
                                print("Failed to parse server object from JSON.")
                                assert(false)
                            }
                        }
                        completionHandler(serverList, nil)
                    }
                    else {
                        print("Failed to get servers list from received data.")
                        assert(false)
                        completionHandler(nil, RequestError.unknownFailure)
                    }
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
    
    func abortAllLoadingTasks() {
        activeSession?.invalidateAndCancel()
        activeSession = nil
    }
}
