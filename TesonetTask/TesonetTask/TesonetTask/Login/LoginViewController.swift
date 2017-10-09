//
//  LoginViewController.swift
//  TesonetTask
//
//  Created by Artyom Belenkov on 10/8/17.
//  Copyright © 2017 abelenkov. All rights reserved.
//

import Cocoa

protocol LoginViewControllerDelegate : class {
    func didRequestLogin(vc:LoginViewController)
}

class LoginViewController: NSViewController {

    @IBOutlet private weak var passwordViewContainer: NSView!
    @IBOutlet private weak var loginViewContainer: NSView!
    @IBOutlet private weak var loginTextField: NSTextField!
    @IBOutlet private weak var passwordTextField: NSSecureTextField!
    @IBOutlet private weak var loginButton: NSButton!
    
    @IBOutlet fileprivate weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var backgroundWidthConstraint: NSLayoutConstraint!
    
    private weak var delegate : LoginViewControllerDelegate?
    internal weak var containerViewController: ContainerViewController? {
        get {
            return delegate as? ContainerViewController
        }
        set {
            delegate = newValue
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction private func loginAction(_ sender: NSButton) {
        delegate?.didRequestLogin(vc: self)
    }
    
    private func setupUI() {
    	passwordViewContainer.wantsLayer = true
        passwordViewContainer.layer?.cornerRadius = 3.0
        passwordViewContainer.layer?.backgroundColor = NSColor.white.cgColor
        
        loginViewContainer.wantsLayer = true
        loginViewContainer.layer?.cornerRadius = 3.0
        loginViewContainer.layer?.backgroundColor = NSColor.white.cgColor
    	
		loginButton.title = NSLocalizedString("cLoginButtonTitle", comment: "")
        passwordTextField.placeholderString = NSLocalizedString("cPasswordPlaceholder", comment: "")
        loginTextField.placeholderString = NSLocalizedString("cUserNamePlaceholder", comment: "")
    }
    
}

extension LoginViewController : IBaseController {
	internal func resetConstrains() {
    	backgroundHeightConstraint.isActive = false
        backgroundWidthConstraint.isActive = false
    }
}
