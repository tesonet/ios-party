//
//  TSLBaseViewController.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/4/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import UIKit

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
	
	// MARK: - Keyboard.
	
	// MARK: Keyboard. Notifications observers.
	
	var hidesKeyboardOnTap: Bool = true
	
	private var keyboardWillAppearObserver: NSObjectProtocol!
	private var keyboardWillDisappearObserver: NSObjectProtocol!
	
	private func addKeyboardObservers() {
		
		if keyboardWillAppearObserver == nil {
			keyboardWillAppearObserver = NotificationCenter.default
				.addObserver(forName: .UIKeyboardWillShow,
										 object: .none,
										 queue: .main) { [unowned self] (notification) in
											self.keyboardWillShow(notification)
			}
		}
		if keyboardWillDisappearObserver == nil {
			keyboardWillDisappearObserver = NotificationCenter.default
				.addObserver(forName: .UIKeyboardWillHide,
										 object: .none,
										 queue: .main) { [unowned self] (notification) in
											self.keyboardWillHide(notification)
			}
		}
		
	}
	
	private func removeKeyboardObservers() {
		
		if let keyboardWillAppearObserver = keyboardWillAppearObserver {
			NotificationCenter.default.removeObserver(keyboardWillAppearObserver)
			self.keyboardWillAppearObserver = .none
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
	
	@objc
	func keyboardWillShow(_ notification: Notification) {
		
		keyboadHidingTapGestureRecognizer.isEnabled = hidesKeyboardOnTap
		keyboadHidingTapGestureRecognizer.cancelsTouchesInView = hidesKeyboardOnTap
		
	}
	
	@objc
	func keyboardWillHide(_ notification: Notification) {
		
		keyboadHidingTapGestureRecognizer.isEnabled = false
		keyboadHidingTapGestureRecognizer.cancelsTouchesInView = false
		
	}
	
}
