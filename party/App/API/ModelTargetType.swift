//
//  ModelTargetType.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

/// `Moya TargetType` with typealias `T: JSONJoy`
protocol ModelTargetType { associatedtype T: Decodable }

protocol MethodPOST: Moya.TargetType {
    var parameters: [String: Any]? { get }
    var baseURL: URL { get }
}

//MARK: - Request method implementation

extension MethodPOST {
    var parameters: [String: Any]? { return nil }
    
    var task: Moya.Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        } else {
            return .requestPlain
        }
    }
    
    var method: Moya.Method { return .post }
    var baseURL: URL { return API.baseURL }
}


// MARK: - request() methods

extension ModelTargetType where Self: Moya.TargetType {

    func request() -> RxSwift.Single<T> {
        return RxMoyaProviderRequest(self)
            .map(T.self)
            .do(onError: {
                print($0)
            })
    }
}

// MARK: - TargetType Provider caching
private func RxMoyaProviderRequest<T: TargetType>(_ target: T) -> RxSwift.Single<Moya.Response> {
    let provider = MoyaProvider<T>.defaultProvider()
    
    return provider
        .request(target)
        .do(onSuccess: { _ in let _ = provider })
}
