//
//  TSLProvider.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya

/// Requests povider for non-auth targets.
final class TSLProvider<Target: TargetType>: MoyaProvider<Target> {
	
	override init(
		endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
		requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
		stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
		callbackQueue: DispatchQueue? = nil,
		manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
		plugins: [PluginType] = [],
		trackInflights: Bool = false)
	{
		
		var plugins = plugins
		// For bearer token header & 401 response.
		plugins.append(TSLUserSessionManager.shared)
		
		super.init(endpointClosure: endpointClosure,
							 requestClosure: requestClosure,
							 stubClosure: stubClosure,
							 callbackQueue: callbackQueue,
							 manager: manager,
							 plugins: plugins,
							 trackInflights: trackInflights)
		
	}
	
}
