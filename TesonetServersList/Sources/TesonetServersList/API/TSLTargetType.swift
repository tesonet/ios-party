//
//  TSLTargetType.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/5/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya

protocol TSLTargetType: TargetType {
	
}

extension TSLTargetType {
	
	var baseURL: URL {
		return URL(string: "http://playground.tesonet.lt/v1/")! // swiftlint:disable:this force_unwrapping
	}
	
	var headers: [String : String]? {
		return .none
	}
	
	var validate: Bool {
		return true
	}
	
}
