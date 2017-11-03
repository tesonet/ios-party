import UIKit
import SnapKit
import IHKeyboardAvoiding

private enum Form: Int {
    case logIn
    case loading
}

class StartupViewController: UIViewController {
    private let loginView = LoginView.loadFromNib()
    private let loadingView = LoadingView.loadFromNib()
    private let loginService = LoginService()
    private let serverService = ServerListService()
    
    private var activeForm = Form.logIn
    
    var onServersLoaded: ((Servers) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        setupLoadingView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStartingForm()
    }
    
    // MARK: Setup
    
    private func setupStartingForm() {
        if Authentication.isUserLoggedIn {
            showLoadingForm(with: __("logging_in")) { [ weak self] in
                self?.login(
                    with: Authentication.userCredentials?.username ?? "",
                    and: Authentication.userCredentials?.password ?? ""
                )
            }
        } else {
            showLoginForm(with: nil)
        }
    }
    
    private func setupLoginView() {
        view.addSubview(loginView)
        KeyboardAvoiding.avoidingView = loginView
        loginView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-33)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        loginView.onLoginTap = { [weak self] in
            self?.onLoginTap()
        }
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        loadingView.alpha = 0
        loadingView.isUserInteractionEnabled = false
    }
    
    // MARK: Form handling
    
    private func fallbackToLoginWith(error: ServiceError) {
        switch error {
        case .unouthorized: showLoginForm(with: __("invalid_credentials"))
        case .unknown: showLoginForm(with: __("something_went_wrong"))
        }
    }
    
    private func userLoggedInWith(username: String, password: String, token: String) {
        Authentication.userCredentials = Credentials(username: username, password: password)
        Authentication.serviceToken = token
        showLoadingForm(with: __("fetching_servers")) { [weak self] in
            self?.loadServers()
        }
    }
    
    private func onLoginTap() {
        view.endEditing(true)
        showLoadingForm(with: __("logging_in")) { [ weak self] in
            self?.login(
                with: self?.loginView.usernameTextField.text ?? "",
                and: self?.loginView.passwordTextField.text ?? ""
            )
        }
    }
    
    // MARK: Networking
    
    private func login(with username: String, and password: String) {
        loginService.loginUser(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                self?.userLoggedInWith(username: username, password: password, token: token)
            case .error(let error):
                self?.fallbackToLoginWith(error: error)
            }
        }
    }
    
    private func loadServers() {
        serverService.fetchServers { [weak self] result in
            switch result {
            case .success(let servers): self?.onServersLoaded?(servers)
            case .error(let error): self?.fallbackToLoginWith(error: error)
            }
        }
    }
    
    // MARK: Form switching
    
    private func showLoadingForm(with message: String?, completion: (() -> Void)? = nil) {
        if activeForm != .loading  {
            activeForm = .loading
            loadingView.animate()
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.loginView.alpha = 0
                self?.loadingView.alpha = 1
            }, completion: { _ in
                completion?()
            })
        } else {
            completion?()
        }
        loadingView.message = message
    }
    
    private func showLoginForm(with error: String?, completion: (() -> Void)? = nil) {
        if activeForm != .logIn {
            activeForm = .logIn
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.loadingView.alpha = 0
                self?.loginView.alpha = 1
            }, completion: { [weak self] _ in
                self?.loadingView.stopAnimation()
                completion?()
            })
        } else {
            completion?()
        }
        loginView.errorLabel.text = error
    }
    
    // MARK: Keyboard Hiding
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
