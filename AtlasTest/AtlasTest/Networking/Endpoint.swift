//
//  Endpoint.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var httpHeaders: [String: String] { get }
    var parameters: [String: String] { get }
    var body: [String: AnyObject] { get }
}

extension Endpoint {
    func request() -> URLRequest? {
        guard let url = URL(string: path) else { return nil }
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components from \(url)")
        }
        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        guard let finalURL = components.url else {
            fatalError("Unable to retrieve final URL")
        }
        var request = URLRequest(url: finalURL)
        for header in httpHeaders {
            request.setValue(String(describing: header.value), forHTTPHeaderField: header.key)
        }
        request.httpMethod = method.rawValue
        request.httpShouldUsePipelining = true
        do {
            if !body.isEmpty {
                let jsonBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.httpBody = jsonBody
            }
        } catch {
            fatalError("Unable to parse JSON")
        }
        return request
    }
}
