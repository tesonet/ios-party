//
//  APIError.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/7/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

/// Errors occured during comunication with backend.
///
/// - cantCastServerResponse: can't cast server response to the expected one.
enum APIError: Swift.Error {
	
	case cantCastServerResponse(from: Any.Type, to: Any.Type)
	case serverReturnedErrorMessage(ServerError, Error)
	
	case sessionExpired
	
}

extension APIError: LocalizedError {
	
	private var localizationKey: String {
		switch self {
		case .cantCastServerResponse:
			return "CANT CAST SERVER RESPONSE"
		case .serverReturnedErrorMessage:
			return "SERVER RETURNED ERROR"
		case .sessionExpired:
			return "SESSION EXPIRED"
		}
	}
	
	private var localizationTable: String {
		return "APIErrors"
	}
	
	var errorDescription: String? {
		let localizedDescription: String = localizationKey.appending(".DESCR").localized(using: localizationTable)
		switch self {
		case let .cantCastServerResponse(from: from, to: to):
			return String(format: localizedDescription,
										String(describing: from),
										String(describing: to))
		case .serverReturnedErrorMessage,
				 .sessionExpired:
			return localizedDescription
		}
	}
	
	var recoverySuggestion: String? {
		let localizedSuggestion: String = localizationKey.appending(".SUGGEST").localized(using: localizationTable)
		switch self {
		case .cantCastServerResponse,
				 .sessionExpired:
			return localizedSuggestion
		case let .serverReturnedErrorMessage(errorMessage, _):
			return String(format: localizedSuggestion, errorMessage.message)
		}
	}
	
}
