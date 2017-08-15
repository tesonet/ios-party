//
//  UnboxableMoya.swift
//  iOS Party
//
//  Created by Justas Liola on 15/08/2017.
//  Copyright © 2017 JL. All rights reserved.
//

import Unbox
import Moya
import RxSwift

/// Extension for processing Responses into Mappable objects through Unbox
public extension ObservableType where E == Response {
    
    /// Maps data received from the signal into an object (on the default Background thread) which
    /// implements the Mappable protocol and returns the result back on the MainScheduler.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Unboxable>(_ type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<T> in

                if let model: T = try? unbox(data: response.data) {
                    return Observable.just(model)
                } else {
                    print("Failed to parse object")
                    return Observable.empty()
                }
            }
            .observeOn(MainScheduler.instance)
    }
    
    /// Maps data received from the signal into an array of objects (on the default Background thread)
    /// which implement the Mappable protocol and returns the result back on the MainScheduler
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Unboxable>(_ type: T.Type) -> Observable<[T]> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<[T]> in

                if let array: [T] = try? unbox(data: response.data) {
                    return Observable.just(array)
                } else {
                    print("Failed to parse array")
                    return Observable.empty()
                }   
            }
            .observeOn(MainScheduler.instance)
    }
}
