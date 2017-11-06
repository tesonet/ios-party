//
//  TSLLoginViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable
import Moya

final class TSLLoginViewController: TSLBaseViewController, StoryboardBased {
	
	private let provider: MoyaProvider<TSLAuthorization> = MoyaProvider<TSLAuthorization>()
	
}

extension TSLLoginViewController: TSLCredentilasViewDelegate {
	
	func tslCredentilasViewDidPressLoginButton(_ credentialsView: TSLCredentilasView) {
		
		provider.request(.authorize) { [unowned self] (result) in
			switch result {
			case let .success(moyaResponse):
				do {
					let token = try moyaResponse.map(String.self, atKeyPath: "token")
					let statusCode = moyaResponse.statusCode
				} catch {
					self.showError(error)
				}
			// do something with the response data or statusCode
			case let .failure(error):
				self.showError(error)
			}
		}
		
	}
	
	func tslCredentilasView(
		_ credentialsView: TSLCredentilasView,
		didReceive validationError: Error)
	{
		showError(validationError)
	}
	
}
