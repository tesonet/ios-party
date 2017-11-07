//
//  AuthorizationAPIModuleProtocol.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Alamofire

/// Authorization.
protocol AuthorizationAPIModuleProtocol {
	
	/// Makes and handles authorization request.
	///
	/// - Parameters:
	///   - credentials: user's credentials for authorization..
	///   - completionHandler: completion handler that takes `result` as a parameter.
	///   - result: `Alamofire.Result<Void>`.
	func authorize(
		with credentials: TSLAuthorizationAPITargets.Credentials,
		completionHandler: @escaping (_ result: Alamofire.Result<Void>) -> Void)
	
}
