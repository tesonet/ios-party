import UIKit

final class LoginViewController: UIViewController {

    private let loginService = LoginService()
    private let serversService = ServersService()
    
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
        view.addSubview(loadingView)
        NSLayoutConstraint.fill(view: view, with: loadingView)
        loginService.getToken(credentials: credentials) { [weak self] result in
            switch result {
            case .success(let token):
                self?.handleSuccessfulLogIn(with: token)
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    private func handleSuccessfulLogIn(with token: String) {
        loadServers(with: token)
    }
    
    private func loadServers(with token: String) {
        serversService.getServers(token: token) { [weak self] result in
            switch result {
            case .success(let serverList):
                self?.presentServers(serversResponse: serverList)
            case .failure(let error): ()
            }
        }
    }
    
    private func presentServers(serversResponse: ServersResponse) {
        let serversViewController = ServersViewController(serversResponse: serversResponse)
        present(serversViewController, animated: true)
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
        
//        loadServers(with: "f9731b590611a5a9377fbd02f247fcdf")
    }
}

