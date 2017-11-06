//
//  TSLAuthorization.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/5/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya

enum TSLAuthorization {
	
	case authorize
	
}

extension TSLAuthorization: TSLTargetTypeV1 {
	
	var path: String {
		switch self {
		case .authorize:
			return "tokens"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .authorize:
			return .post
		}
	}
	
	var sampleData: Data {
		switch self {
		case .authorize:
			return try! JSONSerialization.data(withJSONObject: ["token" : "token"], options: .prettyPrinted)
			// swiftlint:disable:previous force_try
		}
	}
	
	var task: Task {
		switch self {
		case .authorize:
			return .requestParameters(parameters: ["username": "tesonet",
																						 "password": "partyanimal"],
																encoding: JSONEncoding.default)
		}
	}
	
}
