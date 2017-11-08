//
//  TSLServerMessageExtractor.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya
import Result

final class TSLServerMessageExtractor: PluginType {
	
	final func process(
		_ result: Result<Response, MoyaError>,
		target: TargetType)
		-> Result<Response, MoyaError>
	{
		
		guard
			let error = result.error,
			case let .underlying(underlyingError, underlyingResponse) = error,
			let response = underlyingResponse,
			let serverError = ServerError(response: response)
			else {
				return result
		}
		
		return .failure(.underlying(APIError.serverReturnedErrorMessage(serverError, underlyingError), response))
		
	}
	
}
