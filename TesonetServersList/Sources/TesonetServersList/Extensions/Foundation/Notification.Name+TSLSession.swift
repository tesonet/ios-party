//
//  Notification.Name+TSLSession.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation

extension Notification.Name {
	
	/// Posted immediately after success user login.
	static var tslLogin: Notification.Name {
		return Notification.Name(#function)
	}
	
	/// Posted immediately after user logout.
	static var tslLogout: Notification.Name {
		return Notification.Name(#function)
	}
	
	/// Posted after receiveng 401 response code, and session prolongation failed.
	static var tslSessionExpired: Notification.Name {
		return Notification.Name(#function)
	}
	
}
