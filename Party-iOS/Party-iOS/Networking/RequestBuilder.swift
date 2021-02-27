//
//  RequestBuilder.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

struct RequestBuilder {
    func makeRequest(endpoint: EndPoint, additionalHeaders: Headers?) -> URLRequest {
        let  baseURL = endpoint.baseURL
        let url = endpoint.path.isEmpty ? baseURL : baseURL.appendingPathComponent(endpoint.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        var headers = Headers()
        endpoint.headers?.forEach({ headers[$0] = $1 })
        additionalHeaders?.forEach({ headers[$0] = $1 })
        request.allHTTPHeaderFields = headers
        if case let .parameters(parameters) = endpoint.task {
            request = endpoint.parameterEncoding.encode(urlRequest: &request, parameters: parameters)
        }
        
        return request
    }
}
