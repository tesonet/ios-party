//
//  MoyaError+RecoverySuggestion.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import enum Moya.MoyaError

extension MoyaError {
	
	var recoverySuggestion: String? {
		let nsError: NSError
		switch self {
		case .imageMapping,
				 .jsonMapping,
				 .stringMapping,
				 .statusCode,
				 .requestMapping:
			return .none
			
		case let .objectMapping( error, _),
				 let .encodableMapping(error),
				 let .underlying(error, _),
				 let .parameterEncoding(error):
			
			nsError = error as NSError
			
		}
		
		return nsError.localizedRecoverySuggestion
		
	}
	
}
