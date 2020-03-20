//
//  HTTPHandler.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import Foundation
import UIKit

public enum Result<T> {
    
    case success(T)
    case failure(Error)
    
}

typealias ResultCompletion<T: Decodable> = (Result<T>) -> Void

public protocol HTTPHandlerRequest {
    
    func endPoint() -> String
    
    func method() -> String
    
    func parameters() -> [String: Any]?
    
    func headers() -> [String: String]
    
}

public enum HttpHandlerError: Error {
    
    case wrongStatusCode(message: String?)
    case serverResponseNotParseable(message: String?)
    case notHttpResponse(message: String?)
    case noDataFromServer
    case unauthorized
    
}

extension HttpHandlerError: LocalizedError {
    
    private func concatMessage(error: String, message: String?) -> String {
        
        var result = error
        
        if let unwrappedMessage = message {
            result.append(" : ")
            result.append(unwrappedMessage)
        }
        
        return result
    }
    
    public var errorDescription: String? {
        switch self {
        case .notHttpResponse(message: let message):
            return concatMessage(error: "Not http response", message: message)
        case .wrongStatusCode(message: let message):
            return concatMessage(error: "Wrong http status code", message: message)
        case .serverResponseNotParseable(message: let message):
            return concatMessage(error: "Response parsing failed", message: message)
        case .noDataFromServer:
            return "No data from server"
        case .unauthorized:
            return "Wrong credentials"
        }
    }
    
}

public protocol IHTTPHandler: class {
    
    func make<T: Codable>(request: HTTPHandlerRequest,
                          completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask?
    
}

class Response<T: Codable>: Codable {
    
    var result: T
    
}

public protocol IHTTPRequestBodyCreator {
    func buildBody(request: HTTPHandlerRequest) throws -> Data?
}

public class JSONBodyCreator: IHTTPRequestBodyCreator {
    
    public init() {
    }
    
    public func buildBody(request: HTTPHandlerRequest) throws -> Data? {
        
        if let params = request.parameters(),
           request.method() != "GET" {
            let paramsData = try JSONSerialization.data(withJSONObject: params,
                                                        options: JSONSerialization.WritingOptions(rawValue: 0))
            return paramsData
        } else {
            return nil
        }
    }
}

open class HTTPHandler: IHTTPHandler {
    
    let urlSession: URLSession
    let baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
        self.urlSession = URLSession(configuration: .default)
    }
    
    fileprivate func handleResponse<T: Decodable>(_ error: Error?,
                                                  _ response: HTTPURLResponse,
                                                  _ data: Data?,
                                                  completion: @escaping (T?, [AnyHashable: Any], Error?) -> Void) {
        DispatchQueue.main.async {
            
            if let error = error {
                if error._code != -999 {
                    completion(nil, response.allHeaderFields, error)
                }
                return
            }
            
            if let dataToParse = data {
                
                switch response.statusCode {
                case 200, 201, 202, 203, 204, 403, 400:
                    let jsonDecoder = JSONDecoder()
                    
                    do {
                        let parsedData = try jsonDecoder.decode(T.self, from: dataToParse)
                        completion(parsedData, response.allHeaderFields, error)
                    } catch {
                        let jsonString = String(data: dataToParse, encoding: String.Encoding.utf8)
                        completion(nil,
                                   response.allHeaderFields,
                                   HttpHandlerError.serverResponseNotParseable(message: jsonString))
                    }
                case 401:
                    Bindings.shared.logout()
                    completion(nil, response.allHeaderFields, HttpHandlerError.unauthorized)
                default:
                    completion(nil,
                               response.allHeaderFields,
                               HttpHandlerError.wrongStatusCode(message: response.debugDescription))
                }
            } else {
                completion(nil, response.allHeaderFields, HttpHandlerError.noDataFromServer)
            }
            
        }
    }
    
    public func decorateRequest(_ request: inout URLRequest,
                                handlerRequest: HTTPHandlerRequest) throws {
        
        request.httpMethod = handlerRequest.method()
        
        let headers = handlerRequest.headers()
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let body = try JSONBodyCreator().buildBody(request: handlerRequest)
        
        request.httpBody = body
    }
    
    @discardableResult private func run<T: Decodable>(request: HTTPHandlerRequest,
                                                      completion: @escaping (T?, [AnyHashable: Any], Error?) -> Void) -> URLSessionDataTask? {
        
        guard let url = URL(string: self.baseURL + request.endPoint()) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        
        urlRequest.httpMethod = request.method()
        
        do {
            try decorateRequest(&urlRequest, handlerRequest: request)
        } catch let error {
            completion(nil, [:], error)
            return nil
        }
        
        let task = self.urlSession.dataTask(with: urlRequest) { [weak self] (data, pResponse, error) in
            guard let `self` = self else {
                return
            }
            
            guard let response = pResponse as? HTTPURLResponse else {
                
                if let error = error {
                    if error._code != -999 {
                        completion(nil, [:], error)
                    }
                } else {
                    let responseInfo = pResponse.debugDescription
                    completion(nil, [:], HttpHandlerError.notHttpResponse(message: responseInfo))
                }
                
                return
            }
            
            self.handleResponse(error, response, data, completion: completion)
            
        }
        
        task.resume()
        return task
    }
    
    @discardableResult public func make<T: Decodable>(request: HTTPHandlerRequest,
                                                      completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask? {
        
        return self.run(request: request) { (result: T?, _, error: Error?) in
            
            if let error = error {
                completion(Result.failure(error))
                return
            }
            guard let result = result else {
                completion(Result.failure(HttpHandlerError.noDataFromServer))
                return
            }
            
            completion(Result.success(result))
        }
        
    }
    
}
