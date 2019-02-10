//
//  LoginViewController.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import UIKit

final class LoginViewController: BaseController {
    @IBOutlet var roundedViews: [UIView]! {
        didSet {
            roundedViews.forEach { $0.layer.cornerRadius = 5 }
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.isHidden = true
        }
    }
    @IBOutlet weak var usernameField: UITextField! {
        didSet {
            usernameField.delegate = self
        }
    }
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            loadingIndicator.startAnimating()
            loadingIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var contentContainer: UIView! {
        didSet {
            contentContainer.isHidden = true
        }
    }
    var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.isLoggedIn {
            openServerList()
        } else {
            loadingIndicator.isHidden = true
            contentContainer.isHidden = false
        }
    }
    
    @IBAction func loginAction() {
        showLoader(true)
        do {
            let username = usernameField.text
            let password = passwordField.text
            let credentials = try viewModel.getCredentials(username: username, password: password)
            viewModel.login(with: credentials) { [weak self] (success, errorMessage) in
                self?.showLoader(false)
                if success {
                    self?.openServerList()
                    return
                } else {
                    self?.passwordField.text = ""
                    self?.showError(message: errorMessage, fallbackMessage: "Unable to login, please try again later.")
                }
            }
        } catch {
            showLoader(false)
            if let err = error as? LoginError {
                showError(message: err.message)
            }
        }
    }
    
    private func showLoader(_ show: Bool) {
        loginButton.isHidden = show
        activityIndicator.isHidden = !show
        if show {
            activityIndicator.startAnimating()
        }
    }
    
    private func openServerList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: ServerListViewController.indentifier()) as? ServerListViewController else {
            return
        }
        controller.viewModel = ServerListViewModel()
        show(controller, sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
