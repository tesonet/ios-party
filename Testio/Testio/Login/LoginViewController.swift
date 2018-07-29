//
//  LoginViewController.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxOptional

final class LoginViewController: UIViewController, BindableType {
    
    typealias ViewModelType = LoginViewModelType
    
    var viewModel: ViewModelType
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var logInButton: UIButton!
    @IBOutlet private var loginControlStackView: UIStackView!
    @IBOutlet private var stackViewCenterConstraint: NSLayoutConstraint!
    
    private var loginControlReferenceFrame: CGRect = .zero
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        bindKeyboardNotification()
    }
    
    override func viewDidLayoutSubviews() {
        guard loginControlReferenceFrame == .zero else {
            return
        }
        loginControlReferenceFrame = loginControlStackView.frame
    }
    
    func bindViewModel() {
        usernameTextField.text = viewModel.initialCredentials?.username
        passwordTextField.text = viewModel.initialCredentials?.password
        
        logInButton.rx.tap.asObservable()
            .do(onNext: { [unowned self] _ in
                self.usernameTextField.resignFirstResponder()
                self.passwordTextField.resignFirstResponder()
            })
            .subscribe(viewModel.authorize.inputs)
            .disposed(by: disposeBag)
        
        viewModel.areCredentialsValidForSubmit
            .bind(to: logInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let credentialsObservable = Observable.combineLatest(usernameTextField.rx.text.filterNil().distinctUntilChanged(),
                                                             passwordTextField.rx.text.filterNil().distinctUntilChanged())
        credentialsObservable
            .bind(to: viewModel.credentialsConsumer)
            .disposed(by: disposeBag)
    }

}

extension LoginViewController {
    
    private func bindKeyboardNotification() {
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillChangeFrame)
            .map { [unowned self] notification -> (CGFloat, TimeInterval)? in
                let userInfo = notification.userInfo
                guard let endFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
                    let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                        return nil
                }
                let intersection = self.loginControlReferenceFrame.intersection(endFrame)
                let heightOffset = intersection.isNull ? 0 : intersection.height
                return (heightOffset, duration)
            }
            .filterNil()
            .do(onNext: { [unowned self] animationProperties in
                self.animateStackViewCenter(toOffset: animationProperties.0,
                                            animationDuration: animationProperties.1)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func animateStackViewCenter(toOffset offset: CGFloat, animationDuration: TimeInterval) {
        self.stackViewCenterConstraint.constant = -offset
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension LoginViewController {
    
    private func setupAppearance() {
        view.backgroundColor = .clear
        setupTextFields()
        setupButton()
    }
    
    private func setupTextFields() {
        let usernamePlaceholder = NSLocalizedString("USERNAME_PLACEHOLDER", comment: "")
        usernameTextField.placeholder = usernamePlaceholder
        usernameTextField.clearButtonMode = .whileEditing
        image(#imageLiteral(resourceName: "ico-username"), forTextField: usernameTextField)
        
        let passwordPlaceholder = NSLocalizedString("PASSWORD_PLACEHOLDER", comment: "")
        passwordTextField.placeholder = passwordPlaceholder
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        image(#imageLiteral(resourceName: "ico-lock"), forTextField: passwordTextField)
    }
    
    private func image(_ image: UIImage, forTextField textField: UITextField) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 13)
        imageView.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
        textField.leftView = imageView
    }
    
    private func setupButton() {
        let loginButtonTitle = NSLocalizedString("PERFORM_LOG_IN", comment: "")
        logInButton.setTitle(loginButtonTitle, for: .normal)
        logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        logInButton.backgroundColor = Colors.actionColor
        logInButton.layer.cornerRadius = 5
    }
    
}
