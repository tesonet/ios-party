//
//  TSLBaseViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit
import enum Moya.MoyaError

class TSLBaseViewController: UIViewController, UIGestureRecognizerDelegate {
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	// MARK: - Lifecycle.
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureKeyboardHidingTapGesture()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		addKeyboardObservers()
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if isMovingFromParentViewController {
			view.endEditing(true)
		}
		
		removeKeyboardObservers()
		
	}
	
	deinit {
		removeKeyboardObservers()
	}
	
	// MARK: - Error.
	
	func showError(
		_ error: Error,
		onDismiss handler: (() -> Void)? = .none)
	{
		
		let recoverySuggestion: String?
		if let error = error as? MoyaError {
			recoverySuggestion = error.recoverySuggestion
			if
				// if thist is MoyaError for APIError.sessionExpired - dont show, if on dismiss
				// handler not set
				case let .underlying(underlyingError, _) = error,
				let apiError = underlyingError as? APIError,
				case APIError.sessionExpired = apiError,
				handler == nil
			{
				return
			}
		} else {
			recoverySuggestion = (error as? LocalizedError)?.recoverySuggestion
		}
		let alert = UIAlertController(title: error.localizedDescription,
																	message: recoverySuggestion,
																	preferredStyle: .alert)
		
		let dismissAction = UIAlertAction(title: "DISMISS".localized(),
																			style: .cancel) { (_) in handler?() }
		
		alert.addAction(dismissAction)
		
		present(alert, animated: true, completion: .none)
		
	}
	
	// MARK: - Keyboard.
	
	// MARK: Keyboard. Notifications observers.
	
	var hidesKeyboardOnTap: Bool = true
	
	private var keyboardWillAppearObserver: NSObjectProtocol!
	private var keyboardWillChangeFrameObserver: NSObjectProtocol!
	private var keyboardWillDisappearObserver: NSObjectProtocol!
	
	private func addKeyboardObservers() {
		
		unowned let uSelf = self
		if keyboardWillAppearObserver == nil {
			keyboardWillAppearObserver = NotificationCenter.default
				.addObserver(forName: .UIKeyboardWillShow,
										 object: .none,
										 queue: .main,
										 using: uSelf.handleKeyboardNotification)
		}
		if keyboardWillChangeFrameObserver == nil {
			keyboardWillChangeFrameObserver = NotificationCenter.default
				.addObserver(forName: .UIKeyboardWillChangeFrame,
										 object: .none,
										 queue: .main,
										 using: uSelf.handleKeyboardNotification)
		}
		if keyboardWillDisappearObserver == nil {
			keyboardWillDisappearObserver = NotificationCenter.default
				.addObserver(forName: .UIKeyboardWillHide,
										 object: .none,
										 queue: .main,
										 using: uSelf.handleKeyboardNotification)
		}
		
	}
	
	private func removeKeyboardObservers() {
		
		if let keyboardWillAppearObserver = keyboardWillAppearObserver {
			NotificationCenter.default.removeObserver(keyboardWillAppearObserver)
			self.keyboardWillAppearObserver = .none
		}
		
		if let keyboardWillChangeFrameObserver = keyboardWillChangeFrameObserver {
			NotificationCenter.default.removeObserver(keyboardWillChangeFrameObserver)
			self.keyboardWillChangeFrameObserver = .none
		}
		
		if let keyboardWillDisappearObserver = keyboardWillDisappearObserver {
			NotificationCenter.default.removeObserver(keyboardWillDisappearObserver)
			self.keyboardWillDisappearObserver = .none
		}
		
		keyboadHidingTapGestureRecognizer?.isEnabled = false
		
	}
	
	// MARK: Keyboard. Tap gesture recognizer
	
	private var keyboadHidingTapGestureRecognizer: UITapGestureRecognizer!
	
	private func configureKeyboardHidingTapGesture() {
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self,
																											action: #selector(keyboadHidingTapGestureRecognized(_:)))
		tapGestureRecognizer.delegate = self
		tapGestureRecognizer.cancelsTouchesInView = false
		tapGestureRecognizer.isEnabled = false
		view.addGestureRecognizer(tapGestureRecognizer)
		self.keyboadHidingTapGestureRecognizer = tapGestureRecognizer
		
	}
	
	@objc
	private func keyboadHidingTapGestureRecognized(_ tapGesture: UITapGestureRecognizer) {
		view.endEditing(true)
	}
	
	// MARK: Keyboard. Notifications handling.
	
	private func handleKeyboardNotification(_ notification: Notification) {
		guard let parameters = KeyboardAppearanceParameters(notification: notification)
			else {
				return
		}
		
		switch notification.name {
		case .UIKeyboardWillShow:
			keyboardWillShow(parameters)
		case .UIKeyboardWillChangeFrame:
			keyboardWillChangeFrame(parameters)
		case .UIKeyboardWillHide:
			keyboardWillHide(parameters)
		default:
			return
		}
		handleKeyboardParameters(parameters)
	}
	
	/// Executed immediately prior to the display of the keyboard.
	/// - important: Subclasses should invoke super’s implementation
	/// to make *hide keyboard on tap* feature properly working.
	///
	/// - Parameter parameters: keyboard appearance parameters.
	func keyboardWillShow(_ parameters: KeyboardAppearanceParameters) {
		
		self.keyboadHidingTapGestureRecognizer.isEnabled = hidesKeyboardOnTap
		self.keyboadHidingTapGestureRecognizer.cancelsTouchesInView = hidesKeyboardOnTap
		
	}
	
	/// Executed immediately prior to a change in the keyboard’s frame.
	///
	/// - Parameter parameters: keyboard appearance parameters.
	func keyboardWillChangeFrame(_ parameters: KeyboardAppearanceParameters) {
		
	}
	
	/// Executed immediately prior to the dismissal of the keyboard.
	/// - important: Subclasses should invoke super’s implementation
	/// to make *hide keyboard on tap* feature properly working.
	///
	/// - Parameter parameters: keyboard appearance parameters.
	func keyboardWillHide(_ parameters: KeyboardAppearanceParameters) {
		
		self.keyboadHidingTapGestureRecognizer.isEnabled = false
		self.keyboadHidingTapGestureRecognizer.cancelsTouchesInView = false
		
	}
	
	/// Executed immediately after `keyboardWill(Show|ChangeFrame|Hide)` methods.
	///
	/// Default implementation of this method does nothing.
	///
	/// - Parameter parameters: keyboard appearance parameters.
	func handleKeyboardParameters(_ parameters: KeyboardAppearanceParameters) {
		
	}
	
}

extension TSLBaseViewController {
	
	/// A struct holding keyboard view information when it's being shown or hidden.
	struct KeyboardAppearanceParameters {
		
		/// Starting frame rectangle of the keyboard in screen coordinates.
		let startFrame: CGRect
		/// Ending frame rectangle of the keyboard in screen coordinates.
		let endFrame: CGRect
		/// Keyboard notification name.
		let notificationName: Notification.Name
		/// The duration of the animation in seconds.
		let animationDuration: TimeInterval
		/// Defines how the keyboard will be animated onto or off the screen.
		let animationCurve: UIViewAnimationCurve
		
		init?(notification: Notification) {
			let availabaleNotifications: [Notification.Name] = [.UIKeyboardWillShow,
																													.UIKeyboardWillChangeFrame,
																													.UIKeyboardWillHide]
			let userInfo = notification.userInfo! // swiftlint:disable:this force_unwrapping
			
			guard
				// if keyboard belongs to the current app
				userInfo[UIKeyboardIsLocalUserInfoKey] as! Bool, // swiftlint:disable:this force_cast
				// and we can handle it
				availabaleNotifications.contains(notification.name)
				else {
					return nil
			}
			
			self.notificationName = notification.name
			
			self.startFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
			self.endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
			
			self.animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
			let animationCurveRawValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve.RawValue ?? 0
			self.animationCurve = UIViewAnimationCurve(rawValue: animationCurveRawValue) ?? .easeOut
			
		}
		
		/// Ending keyboard height.
		var keyboardHeight: CGFloat {
			return UIScreen.main.bounds.size.height - endFrame.origin.y
		}
		
	}
	
}
