import Foundation
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate: class {
    func handleLoginError(error: Error)
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
        HTTPClient.shared
            .loadToken(from: URLs.Tesonet.tokenURL,
                       withParams: params.toJson()) { [weak self] result, error in
                        guard let `self` = self else { return }
                        if let error = error {
                            print(error)
                            DispatchQueue.main.async {
                                self.delegate?.handleLoginError(error: error)
                            }
                            return
                        }
                        
                        guard let accessToken = result else {
                            return
                        }
                        
                        self.saveSession(accessToken: accessToken, username: params.username, password: params.password)
                        DispatchQueue.main.async {
                            self.delegate?.moveToServersList()
                        }
        }
    }
}

extension LoginViewModel {
    fileprivate func saveSession(accessToken: String, username: String, password: String) {
        UserSession.shared.save(token: accessToken, username: username, password: password)
    }
}
