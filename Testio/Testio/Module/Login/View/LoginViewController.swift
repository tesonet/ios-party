//
//  ViewController.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import UIKit

final class LoginViewController: UIViewController, LoginView {
    
    enum Constants {
        static var logoMinHeight: CGFloat {
            80
        }
        
        static var minFormEdgeInset: CGFloat {
            56
        }
        
        static var maxFormWidth: CGFloat {
            500
        }
    }
    
    var onSuccess: (() -> Void)?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    let bgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "bg"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let scrollView: LoginScrollView = {
        let view = LoginScrollView()
        view.contentInsetAdjustmentBehavior = .always
        view.backgroundColor = .clear
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 10
        return view
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo-white"))
        view.contentMode = .center
        return view
    }()
    
    lazy var usernameField: UITextField = {
        let field = LoginTextField()
        field.add(icon: UIImage(named: "ico-username"))
        field.add(placeholder: "Username")
        field.returnKeyType = .next
        field.delegate = self
        field.autocapitalizationType = .none
        field.nextField = passwordField
        return field
    }()
    
    lazy var passwordField: UITextField = {
        let field = LoginTextField()
        field.add(icon: UIImage(named: "ico-lock"))
        field.add(placeholder: "Password")
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        field.delegate = self
        return field
    }()
    
    let loginButton: LoginButton = {
        let button = LoginButton()
        button.addTarget(self, action: #selector(didSelectLoginButton), for: .touchUpInside)
        return button
    }()
    
    var logoHeightConstraint:NSLayoutConstraint?
    
    let viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        setupViews()
        setupConstraints()
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func setupViews() {
        view.addSubview(bgView)
        view.addSubview(scrollView)
        
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)
        
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(stackView)
    }
    
    func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewMaxWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: Constants.maxFormWidth)
        stackViewMaxWidthConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Constants.minFormEdgeInset),
            stackView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.widthAnchor),
            
            stackViewMaxWidthConstraint
        ])
        
        
        logoHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoMinHeight)
        logoHeightConstraint?.isActive = true
        
        scrollView.layoutIfNeeded()
    }

    @objc func handleShowKeyboard(_ notification: Notification) {
        guard let keyboardWindowFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let bottomInset = max(0, view.frame.maxY - keyboardWindowFrame.minY)
        scrollView.contentInset.bottom = bottomInset
        fixFormPosition()
    }
    
    @objc func handleHideKeyboard(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        fixFormPosition()
    }
    
    func fixFormPosition() {
        let availableHeight = view.bounds.height - view.safeAreaInsets.top - scrollView.adjustedContentInset.bottom
        let newTopOffset = max(availableHeight / 2 - stackView.frame.height / 2, Constants.logoMinHeight)
        logoHeightConstraint?.constant = newTopOffset
        scrollView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fixFormPosition()
    }
    
    @objc func didSelectLoginButton() {
        didSubmitForm()
    }
    
    func didSubmitForm() {
        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }
        
        viewModel.login(username: username, password: password)
    }
    
    func startLoading() {
        usernameField.isEnabled = false
        passwordField.isEnabled = false
        loginButton.startAnimation()
    }
    
    func stopLoading() {
        usernameField.isEnabled = true
        passwordField.isEnabled = true
        loginButton.stopAnimation()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let loginField = textField as? LoginTextField else {
            return true
        }
        
        if let nextField = loginField.nextField {
            nextField.becomeFirstResponder()
        } else {
            didSubmitForm()
            loginField.endEditing(true)
        }
        
        return true
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func didStartLogin() {
        startLoading()
    }
    
    func didFinishLoginWithSuccess() {
        stopLoading()
        onSuccess?()
    }
    
    func didFinishLoginWithError(error: String) {
        stopLoading()
        
        let alertController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
