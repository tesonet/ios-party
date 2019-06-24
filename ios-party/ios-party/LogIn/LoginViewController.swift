import UIKit

final class LoginViewController: UIViewController {

    private let loginService = LoginService()
    private let serversService = ServersService()
    
    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.addSubview(loginView)
        NSLayoutConstraint.fill(view: view, with: loginView)
    }
    
    private func authorize(with credentials: Credentials) {
        showActivityIndicator()
        loginService.getToken(credentials: credentials) { [weak self] result in
            self?.hideActivityIndicator()
            switch result {
            case .success(let token):
                self?.handleSuccessfulLogIn(with: token)
            case .failure(let error):
                self?.handleLoginError(error: error)
            }
        }
    }
    
    private func handleSuccessfulLogIn(with token: String) {
        loadServers(with: token)
    }
    
    private func loadServers(with token: String) {
        showActivityIndicator()
        serversService.getServers(token: token) { [weak self] result in
            self?.hideActivityIndicator()
            switch result {
            case .success(let serverList):
                self?.presentServers(serversResponse: serverList)
            case .failure(let error):
                self?.handleServerLoadError(error: error)
            }
        }
    }
    
    private func presentServers(serversResponse: ServersResponse) {
        let serversViewController = ServersViewController(serversResponse: serversResponse)
        serversViewController.delegate = self
        present(serversViewController, animated: true)
    }
    
    private func handleServerLoadError(error: ServicesError) {
        switch error {
        case .apiError, .decodeError, .invalidEndpoint, .invalidResponse, .noData:
            presentGenericError()
        }
    }
    
    private func handleLoginError(error: LoginError) {
        switch error {
        case .notAuthorized:
            presentError(message: "Bad username or password. Try again")
        case .apiError, .decodeError, .encodeError, .invalidEndpoint, .invalidResponse, .noData:
            presentGenericError()
        }
    }
    
    private func presentGenericError() {
        presentError(message: "Something unexpected happened. Please call Tesonet support")
    }

    private func presentError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK", style:
            UIAlertAction.Style.default,
            handler: nil)
        )
        
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    private func reset() {
        loginView.configure(with: Credentials(username: "", password: ""))
    }
}

extension LoginViewController: LoginViewDelegate {
    
    func didTapLogin(with username: String, and password: String, in viewController: LoginView) {
        let credentials = Credentials(username: username, password: password)
        authorize(with: credentials)
    }
}

extension LoginViewController: ServersViewControllerDelegate {
    
    func didLogout(in viewController: ServersViewController) {
        reset()
    }
}

extension LoginViewController: ActivityIndicating {}
