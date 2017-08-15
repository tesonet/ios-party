//
//  ModelTargetType.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Moya
import RxSwift
import Unbox

// MARK: - Protocols

/// `Moya TargetType` with typealias `T: Unboxable`
protocol ModelTargetType: Moya.TargetType { associatedtype T: Unboxable }

/// `Moya TargetType` with typealias `T: Unboxable` for array response
protocol ModelArrayTargetType: ModelTargetType {}

// MARK: Method protocols
protocol  HasMethod                                          { var method: Moya.Method { get } }
protocol  MethodGET:    HasMethod {}; extension MethodGET    { var method: Moya.Method { return .get } }
protocol  MethodPOST:   HasMethod {}; extension MethodPOST   { var method: Moya.Method { return .post } }

// MARK: Authorization
protocol  IsUnauthorized { }

// MARK: - request() methods
extension ModelTargetType {
    func request() -> RxSwift.Observable<T> {
        return MoyaProviderRequest(target: self).mapObject(T.self)
    }
}
extension ModelArrayTargetType {
    func request() -> RxSwift.Observable<[T]> {
        return MoyaProviderRequest(target: self).mapArray(T.self)
    }
}

// MARK: - TargetType Provider caching

private func MoyaProviderRequest<T: TargetType>(target: T) -> RxSwift.Observable<Moya.Response> {
    
    let provider = RxMoyaProvider<T>.defaultProvider(authorized: !(target is IsUnauthorized))
    
    return provider
        .request(target)
        .do(onNext: { _ in provider })
}

let app_disposeBag = DisposeBag()
