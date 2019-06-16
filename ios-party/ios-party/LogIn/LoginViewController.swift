import UIKit

final class LoginViewController: UIViewController {

    private let service = LoginService()
    private lazy var loadingView: LoginLoaderView = {
        let view = LoginLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        let loginView = LoginView()
        loginView.delegate = self
        loginView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginView)
        NSLayoutConstraint.fill(view: view, with: loginView)
    }
    
    private func authorize(with credentials: Credentials) {
        service.getToken(credentials: credentials) { [weak self] result in
        view.addSubview(loadingView)
        NSLayoutConstraint.fill(view: view, with: loadingView)
            switch result {
            case .success(let token):
                self?.handleSuccessfulLogIn(with: token)
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    private func handleSuccessfulLogIn(with token: String) {
        fatalError("Not implemented")
    }
    
    private func handleError(error: LoginError) {
        switch error {
        case .notAuthorized:
            presentError(message: "Bad username or password. Try again")
        case .apiError, .decodeError, .encodeError, .invalidEndpoint, .invalidResponse, .noData:
            presentError(message: "Error happened. Please call Tesonet support")
        }
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
}

extension LoginViewController: LoginViewDelegate {
    
    func didTapLogin(with username: String, and password: String, in viewController: LoginView) {
        let credentials = Credentials(username: username, password: password)
        authorize(with: credentials)
    }
}

