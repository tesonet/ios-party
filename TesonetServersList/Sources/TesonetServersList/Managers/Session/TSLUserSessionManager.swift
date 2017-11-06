//
//  TSLUserSessionManager.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/5/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya
import Result

final class TSLUserSessionManager: PluginType {
	
	static let shared: TSLUserSessionManager = TSLUserSessionManager()
	
	private let keychainManager: TSLKeychainManager = TSLKeychainManager()
	
	private init() {
		
	}
	
	func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
		
		var request = request
		
		let accessToken = keychainManager.accessToken
		
		if !accessToken.isEmpty {
			request.setValue("Bearer ".appending(accessToken), forHTTPHeaderField: "Authorization")
		}
		
		return request
		
	}
	
	func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
		
	}
	
}
