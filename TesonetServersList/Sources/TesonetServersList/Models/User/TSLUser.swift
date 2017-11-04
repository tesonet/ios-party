//
//  TSLUser.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

struct TSLUser {
	
	static var current: TSLUser? {
		return .none
	}
	
	let username: String
	
	private init?() {
		return nil
	}
	
}
