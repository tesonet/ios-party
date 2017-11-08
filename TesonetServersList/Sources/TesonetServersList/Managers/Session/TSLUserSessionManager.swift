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
import protocol Alamofire.RequestAdapter
import protocol Alamofire.RequestRetrier

final class TSLUserSessionManager {
	
	static let shared: TSLUserSessionManager = TSLUserSessionManager()
	
	private let keychainManager: TSLKeychainManager = TSLKeychainManager()
	
	private init() {
		
	}
	
	final var isUserAuthorised: Bool {
		return !keychainManager.accessToken.isEmpty
	}
	
	final func updateAccessToken(_ accessToken: String) {
		let previousToken = keychainManager.accessToken
		keychainManager.accessToken = accessToken
		if !accessToken.isEmpty && previousToken.isEmpty {
			DispatchQueue.main.async {
				NotificationCenter.default.post(Notification(name: .tslLogin))
			}
		}
	}
	
	final func logout() {
		keychainManager.accessToken = ""
		NotificationCenter.default.post(Notification(name: .tslLogout))
	}
	
}

extension TSLUserSessionManager: PluginType {
	
	final func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
		
		var request = request
		
		let accessToken = keychainManager.accessToken
		
		if !accessToken.isEmpty {
			request.setValue("Bearer ".appending(accessToken), forHTTPHeaderField: "Authorization")
		}
		
		return request
		
	}
	
	final func process(
		_ result: Result<Response, MoyaError>,
		target: TargetType)
		-> Result<Response, MoyaError>
	{
		
		guard
			let error = result.error,
			case let .underlying(_, underlyingResponse) = error,
			let response = underlyingResponse,
			response.statusCode == 401
			else {
				return result
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(950)) {
			NotificationCenter.default.post(Notification(name: .tslSessionExpired))
		}
		
		return .failure(.underlying(APIError.sessionExpired, underlyingResponse))
		
	}
	
}
