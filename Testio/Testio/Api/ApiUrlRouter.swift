//
//  ApiUrlRouter.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import Alamofire

/// Custom HTTP header names
enum HttpHeaderName {
    enum ContentType {
        static let name = "Content-Type"
        static let wildcard = "*"
    }
    
    enum Authorization {
        static let name = "Authorization"
        /// API token logged in user
        static let BearerToken = "Bearer %@"
    }
}

enum ApiUrlRouter: URLRequestConvertible {
    case login(Credentials)
    
    static let baseUrlString = (Bundle.main.infoDictionary![AppConfig.InfoPlistKeys.ApiHost]) as! String
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .login:
                return .post
            }
        }
        let params = parameters()
        var urlRequest = URLRequest(url: url())
        urlRequest.httpMethod = method.rawValue
        // Fill headers
        switch self {
        case .login:
            urlRequest.setValue(HttpHeaderName.ContentType.name, forHTTPHeaderField: HttpHeaderName.ContentType.wildcard)
        }
        
        // Encoding
        var encoding: ParameterEncoding {
            switch self {
            default:
                return URLEncoding.methodDependent
            }
        }
        
        return try encoding.encode(urlRequest, with: params)
    }
    
    /// Generates URL for current endpoint
    func url() -> URL {
        // build up and return the URL for each endpoint
        let relativePath: String?
        
        switch self {
        case .login:
            relativePath = "/tokens"
        }
        
        var url = URL(string: baseUrl())!
        
        if let relativePath = relativePath {
            url = url.appendingPathComponent(relativePath)
        }
        
        return url
    }
    
    private func baseUrl() -> String {
        return ApiUrlRouter.baseUrlString
    }
    
    /// Generate parameters dictionary
    private func parameters() -> [String: Any]? {
        switch self {
        case .login(let credentials):
            return credentials.asDict
        }
    }
}
