//
//  LoginViewController.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    var presenter: LoginPresenterProtocol! = nil

    @IBOutlet private weak var loginButton: LoginButton!
    @IBOutlet private weak var usernameTextField: LoginTextField!
    @IBOutlet private weak var passwordTextField: LoginTextField!
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var loadingContainerView: UIView!
    @IBOutlet private weak var loadingView: LoadingView!

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var loadingMessageLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        setupTextFields()
        setupButton()
        setupImages()
    }
    
    private func setupButton() {
        loginButton.isEnabled = presenter.isLoginButtonEnabled
        loginButton.didTap = { [weak self] in
            self?.presenter.logIn()
        }
    }
    
    private func setupImages() {
        backgroundImageView.image = presenter.backgroundImage
        logoImageView.image = presenter.backgroundLogoImage
    }
    
    private func setupTextFields() {
        usernameTextField.set(type: .username)
        passwordTextField.set(type: .password)
        
        usernameTextField.textDidChange = { [weak self] in
            self?.notifyTextChanged()
        }
        
        passwordTextField.textDidChange = { [weak self] in
            self?.notifyTextChanged()
        }
    }
    
    private func notifyTextChanged() {
        presenter.didChange(username: usernameTextField.text, password: passwordTextField.text)
    }
}

extension LoginViewController: LoginViewProtocol {
    func setLoginButton(enabled: Bool) {
        loginButton.isEnabled = enabled
    }
    
    func updateUI(isLoading: Bool) {
        loadingContainerView.isHidden = !isLoading
        loginView.isHidden = isLoading
        
        if isLoading {
            loadingView.startAnimation()
        } else {
            loadingView.stopAnimation()
        }
        
        loadingMessageLabel.text = presenter.loadingMessage
    }
    
    func show(error: Error) {
        
    }
}

extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
