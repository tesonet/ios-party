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
    }
    
    func bindViewModel() {
        logInButton.rx.tap.asObservable()
            .flatMap { self.viewModel.authorize.execute(()) }
            .subscribe()
            .disposed(by: disposeBag)

        let credentialsObservable = Observable.combineLatest(usernameTextField.rx.text.filterNil(),
                                                             passwordTextField.rx.text.filterNil())
        credentialsObservable
            .bind(to: viewModel.credentialsObserver)
            .disposed(by: disposeBag)
    }

}

extension LoginViewController {
    
    private func setupAppearance() {
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
        
        #if DEBUG
            usernameTextField.text = TestioUser.testUser.username
            passwordTextField.text = TestioUser.testUser.password
        #endif
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
