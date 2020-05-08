//
//  API.swift
//  party
//
//  Created by Paulius on 07/01/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum API {
    enum Headers {}
    enum Authentication {}
    enum Servers {}
}

extension API {
    static var baseURL: URL {
        return URL(string: #"https://playground.tesonet.lt/v1/"#)!
    }
}

// MARK: - Default TargetType values

extension Moya.TargetType {
    var baseURL: URL { return API.baseURL }
    var sampleData: Data { return Data() }
    var validate: Bool { return false }
    var headers: [String: String]? { return API.Headers.all }
    var validationType: Moya.ValidationType { return .none }
}

// MARK: - Authorized MoyaProvider
extension MoyaProvider {
    
    static func defaultProvider() -> OnlineProvider<Target> {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 45
        configuration.timeoutIntervalForResource = 45
        
        let session = Alamofire.Session(configuration: configuration)
        
        return OnlineProvider(endpointClosure: { target in
            return MoyaProvider.defaultEndpointMapping(for: target)
        }, requestClosure: { endpoint, closure in

            guard var request = try? endpoint.urlRequest() else { return }
            request.httpShouldHandleCookies = false
            
            closure(.success(request))
        }, session: session, plugins: [ErrorHandler.instance])
    }
}
