//
//  ModelTargetType.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa



//
// NOTE:
// This whole networking setup may be a little bit over kill for such small demo project
// But I am used to working with RxSwift, thus I would like to show how I usually
// Deal with network request
//



// MARK: - Protocols

/// `Moya TargetType` with typealias `T: JSONJoy`
protocol ModelTargetType: Moya.TargetType { associatedtype T: Decodable }

/// `Moya TargetType` with typealias `T: JSONJoy` for array response
protocol ModelArrayTargetType: ModelTargetType {}

//MARK: Request methods
protocol MethodGET {}
protocol MethodPOST {
    var parameters: [String: Any]? { get }
}

//MARK: - Request method implementation

extension MethodGET {
    var parameters: [String: Any]? { return nil }
    var task: Moya.Task { return .requestPlain }
    var method: Moya.Method { return .get }
}

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
}

// MARK: - request() methods

extension ModelTargetType {
    func request() -> RxSwift.Single<T> {
        return RxMoyaProviderRequest(self)
            .map(T.self)
    }
}

extension ModelArrayTargetType {
    func request() -> RxSwift.Single<[T]> {
        return RxMoyaProviderRequest(self)
            .map([T].self)
    }
}

// MARK: - TargetType Provider caching
private func RxMoyaProviderRequest<T: TargetType>(_ target: T) -> RxSwift.Single<Moya.Response> {
    let provider = MoyaProvider<T>.defaultProvider()
    
    return provider
        .request(target)
        .do(onSuccess: { _ in let _ = provider })
}

// MARK: - Default TargetType values

extension Moya.TargetType {
    var sampleData: Data { return Data() }
    var validate: Bool { return false }
    var headers: [String: String]? { return API.Headers.all }
    var baseURL: URL { return API.baseURL }
}
