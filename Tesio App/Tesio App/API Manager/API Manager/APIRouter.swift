//
//  APIRouter.swift
//  Tesio App
//
//  Created by Eimantas Kudarauskas on 7/25/18.
//  Copyright © 2018 Eimantas Kudarauskas. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    private enum HeaderKey {
        static let AcceptLanguage = "Accept-Language"
        static let ContentType = "Content-Type"
        static let Authorization = "Authorization"
    }
    
    case makeCustomRequestWith(urlString: String, method: HTTPMethod, headers: [String:String]?, parameters: [String : Any]?)
    
        func asURLRequest() throws -> URLRequest {
            
            let url: URL = {
                switch self {
                case .makeCustomRequestWith(var urlString, _, _, let params):
                    if let parameters = params {
                        if !parameters.isEmpty {
                            var first = true
                            var prefix = "?"
                
                            for parameter in parameters {
                                if first == true {
                                    first = false
                                } else {
                                    prefix = "&"
                                }
                                urlString.append("\(prefix)\(parameter.key)=\(parameter.value)")
                            }
                        }
                    }
                    print("-------- >--- >-- > Final URL string: \(urlString)")
                    return URL(string: urlString)!
                }
            }()
            
            let request: URLRequest = {
                var urlRequest = URLRequest(url: url)
                
                switch self {
                    case .makeCustomRequestWith(_, let method, let headers, _):
      
                        // Set headers
                        if let headerFields = headers {
                            for (key, value) in headerFields {
                                urlRequest.setValue(value.toBase64(), forHTTPHeaderField: key)
                            }
                        }
                        
                        if method == .get {
                            if let tokenObject = Token.decode() {
                                let authValue = "Bearer \(tokenObject.token)"
                                urlRequest.setValue(authValue, forHTTPHeaderField: HeaderKey.Authorization)
                            }
                        }
                        
                        // Set default headers
                        urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKey.ContentType)
                        urlRequest.setValue("\(Locale.preferredLanguages.joined(separator: ", "))", forHTTPHeaderField: HeaderKey.AcceptLanguage)
                        urlRequest.timeoutInterval = 15
                        urlRequest.httpMethod = method.rawValue
                }
                return urlRequest
            }()
            
            let encoding: ParameterEncoding = JSONEncoding.default
            
            return try encoding.encode(request, with: nil)
        }
}
