//
//  MoyaDefaultProvider.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import RxSwift

extension MoyaProvider {
    
    static func defaultProvider() -> OnlineProvider<Target> {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 45
        configuration.timeoutIntervalForResource = 45
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        
        return OnlineProvider(endpointClosure: { target in
            return MoyaProvider.defaultEndpointMapping(for: target)
        }, requestClosure: { endpoint, closure in
            
            guard var request = try? endpoint.urlRequest() else { return }
            request.httpShouldHandleCookies = false
            
            closure(.success(request))
        }, manager: manager, plugins: [ErrorHandler.instance])
    }
}

final class OnlineProvider<Target> where Target: Moya.TargetType {
    
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false) {
        
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Single<Moya.Response> {
        return provider.rx.request(token)
    }
}
