//
//  TSLServersListTarget.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya

/// Servers targets.
///
/// - getServersList: API target to fetch rervers list.
enum TSLServersListTarget {
	
	case getServersList
	
}

extension TSLServersListTarget: TSLTargetType {
	
	var task: Task {
		switch self {
		case .getServersList:
			return .requestPlain
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getServersList:
			return .get
		}
	}
	
	var path: String {
		switch self {
		case .getServersList:
			return "servers"
		}
	}
	
	var sampleData: Data {
		switch self {
		case .getServersList:
			let json: [[String : Any]] = [
				[
					"name" : "Germany #28",
					"distance": 1_092
				],
				[
					"name" : "Japan #29",
					"distance": 470
				]
			]
			return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
			// swiftlint:disable:previous force_try
		}
	}
	
}
