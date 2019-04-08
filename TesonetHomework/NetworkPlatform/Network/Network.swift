// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Alamofire
import Domain
import RxAlamofire
import RxSwift
import ObjectMapper

final class Network: Networking {
    // MARK: - Variables
    private let config: APIConfig
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    // MARK: - Methods -
    init(config: APIConfig) {
        self.config = config
        let dispatchQos = DispatchQoS(
            qosClass: DispatchQoS.QoSClass.background,
            relativePriority: 1)
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: dispatchQos)
    }
    
    // MARK: - Implementation
    func postItem<T: ImmutableMappable>(_ path: String,
                                        parameters: [String: Any]?,
                                        headers: [String: String]?) -> Observable<T> {
        return requestItem(
            method: .post,
            path: path,
            parameters: parameters,
            headers: headers)
    }
    
    func getItem<T: ImmutableMappable>(_ path: String,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?) -> Observable<T> {
        return requestItem(
            method: .get,
            path: path,
            parameters: parameters,
            headers: headers)
    }

    func getList<T: ImmutableMappable>(_ path: String,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?) -> Observable<[T]> {
        return requestList(
            method: .get,
            path: path,
            parameters: parameters,
            headers: headers)
    }

    func putItem<T: ImmutableMappable>(_ path: String,
                                       parameters: [String: Any]?,
                                       headers: [String: String]?) -> Observable<T> {
        return requestItem(
            method: .put,
            path: path,
            parameters: parameters,
            headers: headers)
    }
    
    func deleteItem<T: ImmutableMappable>(_ path: String,
                                          parameters: [String: Any]?,
                                          headers: [String: String]?) -> Observable<T> {
        return requestItem(
            method: .delete,
            path: path,
            parameters: parameters,
            headers: headers)
    }
    
    func requestItem<T: ImmutableMappable>(method: HTTPMethod,
                                           path: String,
                                           parameters: [String: Any]? = nil,
                                           headers: [String: String]?) -> Observable<T> {
        let absolutePath = "\(config.endpoint)\(path)"
        let headers = combinedHeaders(with: headers)
        let encoding = parameterEncoding(with: method)
        return RxAlamofire
            .request(
                method,
                absolutePath,
                parameters: parameters,
                encoding: encoding,
                headers: headers)
            .debug()
            .observeOn(scheduler)
            .validateJSONResponse()
            .map({ json -> T in
                return try Mapper<T>().map(JSONObject: json)
            })
    }
    
    func requestList<T: ImmutableMappable>(method: HTTPMethod,
                                           path: String,
                                           parameters: [String: Any]? = nil,
                                           headers: [String: String]?) -> Observable<[T]> {
        let absolutePath = "\(config.endpoint)\(path)"
        let headers = combinedHeaders(with: headers)
        let encoding = parameterEncoding(with: method)
        return RxAlamofire
            .request(
                method,
                absolutePath,
                parameters: parameters,
                encoding: encoding,
                headers: headers)
            .debug()
            .observeOn(scheduler)
            .validateJSONResponse()
            .map({ json -> [T] in
                return try Mapper<T>().mapArray(JSONObject: json)
            })
    }

    // MARK: - Helpers
    private func parameterEncoding(with method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get,
             .delete:
            return URLEncoding.default
        case .put,
             .post:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
    
    private func combinedHeaders(with additionalHeaders: [String: String]?) -> [String: String] {
        let defaultHeaders = [
            "Content-Type": "application/json"]
        guard let additionalHeaders = additionalHeaders else {
            return defaultHeaders
        }
        
        return defaultHeaders.merging(
            additionalHeaders,
            uniquingKeysWith: { (_, new) in
                return new
            })
    }
}
