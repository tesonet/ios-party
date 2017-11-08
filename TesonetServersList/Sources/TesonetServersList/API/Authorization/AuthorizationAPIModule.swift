//
//  AuthorizationAPIModule.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import Moya
import Result
import Alamofire

/// Authorization module.
final class AuthorizationAPIModule: AuthorizationAPIModuleProtocol {
	
	private let provider: MoyaProvider<TSLAuthorizationAPITargets> = {
		MoyaProvider(plugins: [TSLServerMessageExtractor()])
	}()
	
	final func authorize(
		with credentials: TSLAuthorizationAPITargets.Credentials,
		completionHandler: @escaping (_ result: Alamofire.Result<Void>) -> Void)
	{
		
		provider.request(.authorize(with: credentials)) { (result) in
			
			guard let value = result.value
				else {
					completionHandler(.failure(result.error!)) // swiftlint:disable:this force_unwrapping
					return
			}
			
			do {
				let bearerToken = try value.mapString(atKeyPath: "token")
				TSLUserSessionManager.shared.updateAccessToken(bearerToken)
			} catch {
				completionHandler(.failure(error))
				return
			}
			
			completionHandler(.success(()))
			
		}
		
	}
	
}
