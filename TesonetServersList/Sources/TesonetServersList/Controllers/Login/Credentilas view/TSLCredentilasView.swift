//
//  TSLLoginView.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

#if DEBUG
#endif

protocol TSLCredentilasViewDelegate: AnyObject {
	
	func tslCredentilasViewDidPressLoginButton(
		_ credentialsView: TSLCredentilasView,
		with credentials: TSLAuthorizationAPITargets.Credentials)
	
	func tslCredentilasView(
		_ credentialsView: TSLCredentilasView,
		didReceive validationError: Error)
	
}

final class TSLCredentilasView: UIView, NibOwnerLoadable {
	
	final weak var delegate: TSLCredentilasViewDelegate?
	
	@IBOutlet final private weak var usernameTextField: TSLTextFieldWithLeftImageView!
	@IBOutlet final private weak var passwordTextField: TSLTextFieldWithLeftImageView!
	
	@IBOutlet final private weak var loginButton: UIButton!
	
	private var textSizeChangeObserver: NSObjectProtocol?
	// MARK: - Lifecycle
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.loadNibContent()
	}
	
	override final func awakeFromNib() {
		super.awakeFromNib()
		
		configure()
		
		textSizeChangeObserver = NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange,
																																		object: .none,
																																		queue: .main)
		{ [unowned self] (_) in
			if #available(iOS 11.0, *) {
				// fixes issue with not resing UIButton.titleLabel frame on .UIContentSizeCategoryDidChange
				self.loginButton.titleLabel?.font = TSLScaledFont.defalut.font(forTextStyle: .subheadline)
			} else {
				self.configureFonts()
			}
		}
	}
	
	deinit {
		if let textSizeChangeObserver = textSizeChangeObserver {
			NotificationCenter.default.removeObserver(textSizeChangeObserver,
																								name: .UIContentSizeCategoryDidChange,
																								object: .none)
			self.textSizeChangeObserver = .none
		}
	}
	
	// MARK: Config
	
	private func configure() {
		
		usernameTextField.leftViewMode = .always
		usernameTextField.leftView = UIImageView(image: .loginUsernameIco)
		
		passwordTextField.leftViewMode = .always
		passwordTextField.leftView = UIImageView(image: .loginPasswordIco)
		
		loginButton.backgroundColor = .loginLoginButtonBackground
		loginButton.tintColor = .loginLoginButtonTint
		
		localize()
		
		configureFonts()
		
		#if DEBUG
			usernameTextField.text = "tesonet"
			passwordTextField.text = "partyanimal"
		#endif
		
	}
	
	private func configureFonts() {
		
		usernameTextField.font = TSLScaledFont.defalut.font(forTextStyle: .footnote)
		passwordTextField.font = TSLScaledFont.defalut.font(forTextStyle: .footnote)
		loginButton.titleLabel?.font = TSLScaledFont.defalut.font(forTextStyle: .subheadline)
		
		if #available(iOS 10.0, *) {
			usernameTextField.adjustsFontForContentSizeCategory = true
			passwordTextField.adjustsFontForContentSizeCategory = true
			loginButton.titleLabel?.adjustsFontForContentSizeCategory = true
		}
		
	}
	
	private func localize() {
		let tableName: String = "Login"
		usernameTextField.placeholder = "USERNAME.PLACEHOLDER".localized(using: tableName)
		passwordTextField.placeholder = "PASSWORD.PLACEHOLDER".localized(using: tableName)
		
		loginButton.setTitle("LOGIN.TEXT".localized(using: tableName), for: .normal)
		
	}
	
	// MARK: - Actions
	
	@IBAction private func loginButtonPressed() {
		
		self.endEditing(true)
		
		let credentials: TSLAuthorizationAPITargets.Credentials
		do {
			credentials = try TSLAuthorizationAPITargets.Credentials(username: usernameTextField.text,
																										 password: passwordTextField.text)
		} catch {
			delegate?.tslCredentilasView(self, didReceive: error)
			return
		}
		delegate?.tslCredentilasViewDidPressLoginButton(self, with: credentials)
		
		loginButton.isEnabled = false
		
	}
	
	final func enableLoginButton() {
		loginButton.isEnabled = true
	}
	
}
