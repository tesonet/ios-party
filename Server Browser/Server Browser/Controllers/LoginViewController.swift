//
//  LoginViewController.swift
//  Server Browser
//
//  Created by Tanya on 10/1/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var loginButton: FancyButton!
    
    // MARK: -
    
    weak var delegate: LoginViewControllerDelegate?
    
    var username: String {
        get {
            loadViewIfNeeded()
            return usernameTextField.stringValue
        }
        
        set {
            loadViewIfNeeded()
            usernameTextField.stringValue = newValue
        }
    }
    
    var password: String {
        get {
            loadViewIfNeeded()
            return passwordTextField.stringValue
        }
        
        set {
            loadViewIfNeeded()
            passwordTextField.stringValue = newValue
        }
    }
    
    // MARK: - NSViewController
    
    override func viewDidLoad() {
        loginButton.setBackgroundColor(NSColor(calibratedRed: 0.60,
                                               green: 0.80,
                                               blue: 0.18,
                                               alpha: 1.0))
        loginButton.setBorderAttributes(color: NSColor.black,
                                        borderWidth: 0.5,
                                        cornerRadius: 5.0)
        loginButton.setText("Log In",
                            font: NSFont.boldSystemFont(ofSize: 12.0),
                            color: NSColor.white)
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: NSButton) {
        guard !usernameTextField.stringValue.isEmpty &&
            !passwordTextField.stringValue.isEmpty else {
                let alert = NSAlert()
                alert.messageText = NSLocalizedString("Cannot Login", comment: "Cannot Login Without Credentials alert title")
                alert.informativeText = NSLocalizedString("Please enter your credentials and try again.", comment: "Cannot Login Without Credentials alert text")
                alert.beginSheetModal(for: view.window!)
                return
        }
        
        delegate?.loginViewControllerDidRequestLogin(self)
    }
    
    // MARK: - Private
    
    func loadViewIfNeeded() {
        if !isViewLoaded {
            _ = view
        }
    }
}
