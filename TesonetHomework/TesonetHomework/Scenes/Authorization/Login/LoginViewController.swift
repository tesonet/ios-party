// Created by Paulius Cesekas on 01/04/2019.

import UIKit
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private(set) weak var logoImageView: UIImageView!
    @IBOutlet private(set) weak var usernameTextField: UITextField!
    @IBOutlet private(set) weak var passwordTextField: UITextField!
    @IBOutlet private(set) weak var loginButton: UIButton!

    // MARK: - Variables
    private var login: PublishSubject<LoginCredentials>!
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    private var input: LoginViewModel.Input!
    private var output: LoginViewModel.Output!
    private lazy var loadingViewController: LoadingViewController = {
        return LoadingViewController(state: L10n.Login.loading)
    }()
    
    // MARK: - Methods -
    class func initialiaze(with viewModel: LoginViewModel) -> LoginViewController {
        let viewController = StoryboardScene.Authorization
            .loginViewController
            .instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
    }

    // MARK: - Configure
    private func configure() {
        guard viewModel != nil else {
            fatalError("`viewModel` is not set")
        }
        
        configureRX()
    }
    
    private func configureRX() {
        login = PublishSubject()
        input = LoginViewModel.Input(login: login.asDriverOnErrorJustComplete())
        output = viewModel.transform(input: input)
        bindOutput(output)
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupLogo()
        setupUsernameTextField()
        setupPasswordTextField()
        setupLoginButton()
    }
    
    private func setupLogo() {
        logoImageView.image = Asset.logoWhite.image
    }
    
    private func setupUsernameTextField() {
        #if DEBUG
        usernameTextField.text = "tesonet"
        #endif
        usernameTextField.placeholder = L10n.Login.Placeholder.username
        usernameTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [unowned self] (_) in
                self.passwordTextField.becomeFirstResponder()
                self.usernameTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    }

    private func setupPasswordTextField() {
        #if DEBUG
        passwordTextField.text = "partyanimal"
        #endif
        passwordTextField.placeholder = L10n.Login.Placeholder.password
        passwordTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [unowned self] (_) in
                self.passwordTextField.resignFirstResponder()
                self.submitLogin()
            }
            .disposed(by: disposeBag)
    }

    private func setupLoginButton() {
        loginButton.setTitle(
            L10n.Login.Button.login,
            for: .normal)
        loginButton.rx
            .tap
            .bind { [unowned self] (_) in
                self.submitLogin()
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                usernameTextField.rx.text.orEmpty.asObservable(),
                passwordTextField.rx.text.orEmpty.asObservable())
            .map({ !$0.0.isEmpty && !$0.1.isEmpty })
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    // MARK: - Rx Binding
    func bindOutput(_ output: LoginViewModel.Output) {
        bindIsLoading(output.isLoading)
        bindError(output.error)
    }
    
    private func bindIsLoading(_ isLoading: Driver<Bool>) {
        isLoading
            .drive(onNext: { [unowned self] (isLoading) in
                self.updateLoadingState(isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindError(_ error: Driver<Error>) {
        error
            .drive(onNext: { [unowned self] (error) in
                self.handleError(error)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers
    private func updateLoadingState(_ isLoading: Bool) {
        guard isLoading else {
            return
        }
        
        showLoading(animated: true)
    }
    
    private func handleError(_ error: Error) {
        guard let networkError = error as? NetworkError else {
            showError(message: error.localizedDescription)
            return
        }
        
        switch networkError {
        case .unauthorized:
            showError(message: L10n.Login.Error.unauthorized)
        case .unacceptableStatusCode(_), // swiftlint:disable:this empty_enum_arguments
             .emptyBody,
             .unserializableBody:
            showError(message: L10n.Common.Error.pleaseTryAgain)
        }
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(
            title: L10n.Common.Error.title,
            message: message,
            preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: L10n.Common.Button.ok,
                style: .default,
                handler: nil))
        hideLoading(animated: false) { [weak self] in
            self?.navigationController?.present(
                alertController,
                animated: true)
        }
    }
    
    private func submitLogin() {
        view.endEditing(true)

        guard !usernameTextField.textOrEmpty.isEmpty else {
            showError(message: L10n.Login.Error.emptyUsername)
            return
        }
        guard !passwordTextField.textOrEmpty.isEmpty else {
            showError(message: L10n.Login.Error.emptyPassword)
            return
        }

        let credentials = LoginCredentials(
            username: usernameTextField.textOrEmpty,
            password: passwordTextField.textOrEmpty)
        self.login.onNext(credentials)
    }
    
    private func showLoading(animated: Bool) {
        loadingViewController.updateState(L10n.Login.loading)
        guard !loadingViewController.isBeingPresented else {
            return
        }
        
        navigationController?.present(
            loadingViewController,
            animated: animated)
    }
    
    private func hideLoading(animated: Bool,
                             completion: (() -> Void)? = nil) {
        loadingViewController.dismiss(
            animated: animated,
            completion: completion)
    }
}
