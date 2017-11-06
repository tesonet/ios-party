//
//  AuthorizationAPIModuleProtocol.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthorizationAPIModuleProtocol {
	
	func authorize(
		with credentials: TSLAuthorizationAPITargets.Credentials,
		completionHandler: @escaping (Alamofire.Result<Void>) -> Void)
	
}
