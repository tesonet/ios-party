//
//  TSLKeychainManager.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/5/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import KeychainAccess

final class TSLKeychainManager {
	
	private let keychain: Keychain = {
		var keychain = Keychain(service: "test")
			.synchronizable(false)
			.label("OAuth token")
			.comment("Stores Bearer access token")
		
		return keychain
		
	}()
	
	var accessToken: String {
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
