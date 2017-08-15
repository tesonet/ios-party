//
//  API.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Moya
import RxMoya
import UIKit
import Alamofire

// MARK: - API

enum API {
    enum Authentication {}
    enum Servers        {}
}

// MARK: - Default TargetType values

extension Moya.TargetType {
    var baseURL:    URL            { return URL(string: "http://playground.tesonet.lt/v1/")! /*Too bad it's not https.*/ }
    var parameters: [String: Any]? { return nil      }
    var sampleData: Data           { return Data()   }
    var task:       Moya.Task      { return .request }
    var parameterEncoding: Moya.ParameterEncoding { return JSONEncoding.default }
}

// MARK: - Authorized RxMoyaProvider

extension RxMoyaProvider {
    
    static func defaultProvider(authorized: Bool) -> RxMoyaProvider<Target> {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        return RxMoyaProvider(endpointClosure: { target in
            let endpoint = RxMoyaProvider.defaultEndpointMapping(for: target)
            return endpoint
        }, requestClosure: { endpoint, closure in
            guard var request = endpoint.adding(newParameterEncoding: JSONEncoding.default).urlRequest else { return }
            API.Headers.all.forEach { request.addValue($0.1, forHTTPHeaderField: $0.0) }
            closure(.success(request))
        }, manager: manager, plugins: [ErrorHandler.instance])
    }
}
