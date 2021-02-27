//
//  EndPoint.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

public protocol EndPoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameterEncoding: HTTPParameterEncoding { get }
    var task: HTTPTask { get }
    var headers: Headers? { get }
    var baseURL: URL { get }
}

public typealias Parameters = [String: Any]
public typealias Headers = [String: String]

public enum HTTPTask {
    case plain
    case parameters(Parameters)
}

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
