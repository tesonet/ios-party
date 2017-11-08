//
//  TSLAuthorizationAPITargets.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/5/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya

/// Authorization targets.
///
/// - authorize: authorization target. Stores user's credentials.
enum TSLAuthorizationAPITargets {
	
	case authorize(with: TSLAuthorizationAPITargets.Credentials)
	
}

extension TSLAuthorizationAPITargets: TSLTargetType {
	
	var task: Task {
		switch self {
		case let .authorize(with: credentials):
			return .requestJSONEncodable(credentials)
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .authorize:
			return .post
		}
	}
	
	var path: String {
		switch self {
		case .authorize:
			return "tokens"
		}
	}
	
	var sampleData: Data {
		switch self {
		case .authorize:
			return try! JSONSerialization.data(withJSONObject: ["token" : "token"], options: .prettyPrinted)
			// swiftlint:disable:previous force_try
		}
	}
	
	var headers: [String : String]? {
		return ["Content-Type" : "application/json"]
	}
	
}
