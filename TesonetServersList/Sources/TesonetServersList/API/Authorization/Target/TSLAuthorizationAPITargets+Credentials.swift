//
//  TSLAuthorizationAPITargets+Credentials.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

extension TSLAuthorizationAPITargets {
	
	/// User's credentials used for authorization.
	struct Credentials {
		
		let username: String
		let password: String
		
	}
	
}

extension TSLAuthorizationAPITargets.Credentials {
	
	init(
		username: String?,
		password: String?) throws
	{
		
		guard
			let username = username,
			!username.isEmpty
			else {
				throw Error.usernameIsEmpty
		}
		guard
			let password = password,
			!password.isEmpty
			else {
				throw Error.passswordIsEmpty
		}
		
		self.username = username
		self.password = password
		
	}
	
}

extension TSLAuthorizationAPITargets.Credentials: Encodable {
	
	private enum CodingKey: String, Swift.CodingKey {
		case username = "username"
		case password = "password"
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKey.self)
		try container.encode(username, forKey: .username)
		try container.encode(password, forKey: .password)
	}
	
}

private extension TSLAuthorizationAPITargets.Credentials {
	
	/// Errors occured on `TSLAuthorization.Credentials` initalization.
	///
	/// - usernameIsEmpty: username is empty or `nil`.
	/// - passswordIsEmpty: password is empty or `nil`.
	enum Error: Swift.Error {
		
		case usernameIsEmpty
		case passswordIsEmpty
		
	}
	
}

extension TSLAuthorizationAPITargets.Credentials.Error: LocalizedError {
	
	private var localizationKey: String {
		switch self {
		case .usernameIsEmpty:
			return "ERROR.NO_USERNAME"
		case .passswordIsEmpty:
			return "ERROR.NO_PASSWORD"
		}
	}
	
	private var localizationTable: String {
		return "Login"
	}
	
	var errorDescription: String? {
		return localizationKey.appending(".DESCR").localized(using: localizationTable)
	}
	
	var recoverySuggestion: String? {
		return localizationKey.appending(".SUGGEST").localized(using: localizationTable)
	}
	
}
