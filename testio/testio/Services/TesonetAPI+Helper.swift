//
//  TesonetAPI+Helper.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import Moya

extension TesonetAPI {
    
    typealias ServiceSuccess<ResultType: Decodable> = (_ result: ResultType, _ response: Response) -> ()
    typealias ServiceError = (_ statusCode: Int?, _ msg: String?, _ error: MoyaError?) -> ()
    typealias Finally = () -> ()
    
    private func completion<ResultType: Decodable>(onSuccess: ServiceSuccess<ResultType>? = nil,
                                                   onError: ServiceError? = nil,
                                                   finally: Finally? = nil) -> Completion {
        return { result in
            
            defer {
                finally?()
            }
            
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                
                if (200...299).contains(statusCode) {
                    do {
                        let result = try moyaResponse.map(ResultType.self)
                        onSuccess?(result, moyaResponse)
                    } catch {
                        onError?(statusCode, "API Data error", nil)
                    }
                } else {
                    let errorMsg = try? moyaResponse.map(ServerMessage.self).message
                    onError?(statusCode, errorMsg, nil)
                }
                
            case let .failure(error):
                onError?(nil, error.localizedDescription, error)
            }
        }
    }
    
    /// Helper method with default handlers.
    ///
    /// - Parameters:
    ///   - caller: UIViewController? used to show default error messages
    ///   - onSuccess: Success handler. Default `nil`
    ///   - errorHandler: Error handler. By default presents an alert with default/server error message using `caller` if provided.
    ///   - finally: Finally handler called regardless of request's result. Default `nil`
    /// - Returns: Returns a Cancellable token to cancel the request later.
    @discardableResult
    func request<ResultType: Decodable>(caller: UIViewController?, onSuccess: ServiceSuccess<ResultType>? = nil,
                                        onError errorHandler: ServiceError? = nil,
                                        finally: Finally? = nil) -> Cancellable {
        let errorHandler = errorHandler ?? {[weak caller] (_,msg,_) in
                guard caller?.view.window != nil else {
                    return
                }
                caller?.presentAlert(withTitle: Strings.Error.localized, message: msg ?? "Something wrong happened...")
            }
        
        return TesonetAPIProvider.request(self, completion: completion(onSuccess: { (result: ResultType, response: Response) in onSuccess?(result, response) },
                                                                       onError: errorHandler, finally: finally))
    }
}
