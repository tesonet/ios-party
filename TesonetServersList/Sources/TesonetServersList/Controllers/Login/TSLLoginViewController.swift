//
//  TSLLoginViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

final class TSLLoginViewController: TSLBaseViewController, StoryboardBased {
	
}

extension TSLLoginViewController: TSLCredentilasViewDelegate {
	
	func tslCredentilasViewDidPressLoginButton(_ credentialsView: TSLCredentilasView) {
		
	}
	
	func tslCredentilasView(
		_ credentialsView: TSLCredentilasView,
		didReceive validationError: Error)
	{
		
	}
	
}
