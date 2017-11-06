//
//  TSLLoginView.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import Reusable

@objc
protocol TSLCredentilasViewDelegate: AnyObject {
	
	func tslCredentilasViewDidPressLoginButton(_ credentialsView: TSLCredentilasView)
	
	func tslCredentilasView(_ credentialsView: TSLCredentilasView, didReceive validationError: Error)
	
}

class TSLCredentilasView: UIView, NibOwnerLoadable {
	
	@IBOutlet weak var delegate: TSLCredentilasViewDelegate?
	// swiftlint:disable:previous private_outlet
	
	@IBOutlet private weak var usernameTextField: TSLTextFieldWithLeftImageView!
	@IBOutlet private weak var passwordTextField: TSLTextFieldWithLeftImageView!
	
	@IBOutlet private weak var loginButton: UIButton!
	
	// MARK: - Lifecycle
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.loadNibContent()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		usernameTextField.leftViewMode = .always
		usernameTextField.leftView = UIImageView(image: .loginUsernameIco)
		
		passwordTextField.leftViewMode = .always
		passwordTextField.leftView = UIImageView(image: .loginPasswordIco)
		
		loginButton.backgroundColor = .loginLoginButtonBackground
		loginButton.tintColor = .loginLoginButtonTint
		
		localize()
		
	}
	
	private func localize() {
		let tableName: String = "Login"
		usernameTextField.placeholder = "USERNAME.PLACEHOLDER".localized(using: tableName)
		passwordTextField.placeholder = "PASSWORD.PLACEHOLDER".localized(using: tableName)
		
		loginButton.setTitle("LOGIN.TEXT".localized(using: tableName), for: .normal)
		
	}
	
	@IBAction func loginButtonPressed() {
		self.endEditing(true)
		do {
			try validate()
		} catch {
			delegate?.tslCredentilasView(self, didReceive: error)
			return
		}
		delegate?.tslCredentilasViewDidPressLoginButton(self)
	}
	
	private func validate() throws {
		guard
			let username = usernameTextField.text,
			!username.isEmpty
			else {
				throw Error.usernameIsEmpty
		}
		guard
			let password = passwordTextField.text,
			!password.isEmpty
			else {
				throw Error.passswordIsEmpty
		}
	}
	
}

extension TSLCredentilasView: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case usernameTextField:
			passwordTextField.becomeFirstResponder()
		case passwordTextField:
			loginButtonPressed()
		default:
			break
		}
		return true
	}
	
}

extension TSLCredentilasView {
	
	enum Error: Swift.Error {
		
		case usernameIsEmpty
		case passswordIsEmpty
		
	}
	
}

extension TSLCredentilasView.Error: LocalizedError {
	
	private var localizationKey: String {
		switch self {
		case .usernameIsEmpty:
			return "ERROR.NO_USERNAME"
		case .passswordIsEmpty:
			return "ERROR.NO_PASSWORD"
		}
	}
	
	private var localizationTable: String {
		return "Login"
	}
	
	var errorDescription: String? {
		return localizationKey.appending(".DESCR").localized(using: localizationTable)
	}
	
	var recoverySuggestion: String? {
		return localizationKey.appending(".SUGGEST").localized(using: localizationTable)
	}
	
}
