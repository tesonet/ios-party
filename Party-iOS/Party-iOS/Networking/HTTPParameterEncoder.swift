//
//  HTTPParameterEncoder.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, parameters: Parameters) -> URLRequest
}

public struct JSONParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, parameters: Parameters) -> URLRequest {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {}
        return urlRequest
    }
}

public struct URLParameterEncoder: ParameterEncoder {
        
    public func encode(urlRequest: inout URLRequest, parameters: Parameters) -> URLRequest {
        guard let url = urlRequest.url else { return urlRequest }
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let queryItem = URLQueryItem(name: key,
                                             value: encodedValue)
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}

public enum HTTPParameterEncoding {
    case url
    case json
    case custom(ParameterEncoder)
}

extension HTTPParameterEncoding: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, parameters: Parameters) -> URLRequest {
        switch self {
        case .url:
            return URLParameterEncoder().encode(urlRequest: &urlRequest, parameters: parameters)
        case .json:
            return JSONParameterEncoder().encode(urlRequest: &urlRequest, parameters: parameters)
        case .custom(let encoder):
            return encoder.encode(urlRequest: &urlRequest, parameters: parameters)
        }
    }
}
