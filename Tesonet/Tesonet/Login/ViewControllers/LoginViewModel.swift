import RxSwift

protocol LoginViewControllerDelegate: class {
    func moveToServersList()
}

protocol LoginViewModelType {
    var delegate: LoginViewControllerDelegate? { get set }
    func retrieveToken(with params: LoginData)
}

class LoginViewModel: LoginViewModelType {
    weak var delegate: LoginViewControllerDelegate?
    private let loginInteractor: LoginInteractor
    private let disposeBag = DisposeBag()
    
    init(loginInteractor: LoginInteractor) {
        self.loginInteractor = loginInteractor
    }
    
    func retrieveToken(with params: LoginData) {
        loginInteractor
            .request(with: params)
            .subscribe(
                onSuccess: { [weak self] accessToken in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        ErrorMessageHud.showError(with: "")
                    }
                    self.saveSession(accessToken: accessToken,
                                     username: params.username,
                                     password: params.password)
                    DispatchQueue.main.async {
                        self.delegate?.moveToServersList()
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        ErrorMessageHud.showError(with: error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel {
    fileprivate func saveSession(accessToken: String, username: String, password: String) {
        UserSession.shared.save(token: accessToken, username: username, password: password)
    }
}
