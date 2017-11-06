//
//  TSLKeychainManager.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/5/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import KeychainAccess

/// Keychain manager.
///
/// Stores bearer access token.
/// - note: Personally I don't think it's right to store username/password anywhere.
/// Usually OAuth has 2 tokens - access & refresh, and I'm storing both of them in the Keychain.
/// On the first 401 status code response - there should be a request of a new access & refresh tokens,
/// using current refresh.
final class TSLKeychainManager {
	
	private let keychain: Keychain = {
		var keychain = Keychain(service: "test")
			.synchronizable(false)
			.label("OAuth token")
			.comment("Stores Bearer access token")
		
		return keychain
		
	}()
	
	final var accessToken: String {
		get {
			do {
				return try keychain.get(#function) ?? ""
			} catch {
				print("Can't get \(#function)")
				return ""
			}
		}
		set {
			do {
				try keychain.set(newValue, key: #function)
			} catch {
				print("Can't set \(#function)")
			}
		}
	}
	
}
