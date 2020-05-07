//
//  Moya+Rx.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import RxSwift
import Alamofire
import Moya
final class OnlineProvider<Target> where Target: Moya.TargetType {
    
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping Moya.MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping Moya.MoyaProvider<Target>.RequestClosure, // = MoyaProvider.defaultRequestMapping,
         stubClosure: @escaping Moya.MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         session: Moya.Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [Moya.PluginType] = [],
         trackInflights: Bool = false) {
        
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     callbackQueue: callbackQueue,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }
    
    func request(_ token: Target) -> Single<Moya.Response> {
        return provider.rx.request(token)
    }
}
