//
//  URLSession+Result.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func uploadTask(with request: URLRequest, from data: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    public func uploadTask(with request: URLRequest, from data: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (uploadTask(with: request, from: data, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    
    public func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (uploadTask(with: request, fromFile: fileURL, completionHandler: completionHandler) as URLSessionUploadTask) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

public typealias DataTaskResult = Result<(URLResponse, Data), Error>

extension URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (DataTaskResult) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url) { (data, response, error) in
            let result = URLSession.resultHandler(data: data, response: response, error: error)
            completion(result)
        }
    }
    
    func dataTask(with request: URLRequest, completion: @escaping (DataTaskResult) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: { (data, response, error) in
            let result = URLSession.resultHandler(data: data, response: response, error: error)
            completion(result)
        })
    }
    
    static func resultHandler(data: Data?, response: URLResponse?, error: Error?) -> DataTaskResult {
        if let error = error {
            return .failure(error)
        }
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            return .failure(error)
        }
        return .success((response, data))
    }
}
