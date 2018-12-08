//
//  NetworkActivityPlugin.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 05/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation
import Moya
import Result

/// Notify a request's network activity changes (request begins or ends).
public final class NetworkActivityPlugin: PluginType {
    
    public init() {
    }
    
    // MARK: Plugin
    public func willSend(_ request: RequestType, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
