//
//  LoginViewController.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import UIKit

final class LoginViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    
    private lazy var usernameField: UITextField = LoginFieldBuilder.makeLoginTextField(placeholder: "Username", image: UIImage(named: "ico-username"))
    
    private lazy var passwordField: UITextField = {
        let textField = LoginFieldBuilder.makeLoginTextField(placeholder: "Password", image: UIImage(named: "ico-lock"))
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = PartyColor.buttonGreen
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo-white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK - Layout Setup
extension LoginViewController {
    private func setupLayout() {
        [backgroundImageView, logoImageView, stackView].forEach { view.addSubview($0) }
        [usernameField, passwordField, loginButton].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            // BackgroundImageView
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //LogoImageView
            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //StackView
            stackView.topAnchor.constraint(equalTo: logoImageView.topAnchor, constant: LayoutConstants.logoBottomMarginConsant),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //UsernameTextField
            usernameField.heightAnchor.constraint(equalToConstant: LayoutConstants.textFieldHeightConstant),
            usernameField.widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.textFieldMinimumWidthConstant),
            //PasswordTextField
            passwordField.heightAnchor.constraint(equalToConstant: LayoutConstants.textFieldHeightConstant),
            passwordField.widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.textFieldMinimumWidthConstant),
            //Button
            loginButton.heightAnchor.constraint(equalToConstant: LayoutConstants.textFieldHeightConstant),
            loginButton.widthAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.textFieldMinimumWidthConstant)
        ])
    }
    
    private class LayoutConstants {
        static let textFieldHeightConstant: CGFloat =  60
        static let textFieldMinimumWidthConstant: CGFloat = 280
        static let logoBottomMarginConsant: CGFloat = 200
    }
}

extension LoginViewController {
    @objc private func loginAction(_ sender: Any) {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            let alertController = UIAlertController(title: "Error", message: "Username or password is empty.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        disableFields(true)
        AuthService().authenticate(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            self.disableFields(false)
            switch result {
            case .success: self.coordinator?.navigate(.list)
            case .failure(let error): self.showErrorAlert(error)
            }
        }
    }
    
    private func disableFields(_ isDisabled: Bool) {
        [usernameField, passwordField, loginButton].forEach { $0.isEnabled = !isDisabled }
    }
    
    private func showErrorAlert(_ error: APIClientError) {
        let message: String = {
            if case .networkError(let networkError) = error,
               case .http(let httpError, _) = networkError,
               case .unauthorized = httpError {
                return "Username or Password is incorrect"
            } else {
                return "Network error occured."
            }
        }()
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
