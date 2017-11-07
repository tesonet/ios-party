//
//  TSLLoginViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable
import Alamofire

final class TSLLoginViewController: TSLBaseViewController, StoryboardBased {
	
	private let authorizationModule: AuthorizationAPIModuleProtocol = AuthorizationAPIModule()
	
	@IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
	
	@IBOutlet private var credentialsView: TSLCredentilasView! {
		didSet {
			credentialsView.delegate = self
		}
	}
	
	// MARK: - Keyboard
	
	override func handleKeyboardParameters(_ parameters: TSLBaseViewController.KeyboardAppearanceParameters) {
		
		let defaultBottomConstaint: CGFloat = 50.0
		
		let bottomInset: CGFloat = defaultBottomConstaint + parameters.keyboardHeight
		
		guard bottomConstraint.constant != bottomInset
			else {
				return
		}
		
		bottomConstraint.constant = bottomInset
		
		animateLayout(duration: parameters.animationDuration, curve: parameters.animationCurve)
		
	}
	
	func animateLayout(
		duration animationDuration: TimeInterval,
		curve animationCurve: UIViewAnimationCurve)
	{
		
		UIView.beginAnimations("Insets setup", context: .none)
		UIView.setAnimationDuration(animationDuration)
		UIView.setAnimationCurve(animationCurve)
		UIView.setAnimationBeginsFromCurrentState(true)
		view.layoutIfNeeded()
		
		UIView.commitAnimations()
		
	}
	
}

extension TSLLoginViewController: TSLCredentilasViewDelegate {
	
	func tslCredentilasViewDidPressLoginButton(
		_ credentialsView: TSLCredentilasView,
		with credentials: TSLAuthorizationAPITargets.Credentials)
	{
		
		authorizationModule.authorize(with: credentials) { [unowned self] (result) in
			// `unowned` because controller should & will be alive during the request.
			
			defer {
				self.credentialsView.enableLoginButton()
			}
			
			guard result.isSuccess
				else {
					self.showError(result.error!) // swiftlint:disable:this force_unwrapping
					return
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
