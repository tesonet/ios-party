
import Foundation
import PromiseKit


class LoginDataModel {
    
    private let sessionContext: SessionContext
    
    weak var presenter: LoginPresenter?
    
    
    // MARK: - Init
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    
    // MARK: - Public
    func login(with username: String,
               password: String) {
        let request = sessionContext
            .services
            .auth
            .login(with: username, password: password)
        
        request.done { [weak self] response in
            self?.sessionContext.session.activate(with: response.token)
            self?.presenter?.presentSuccess()
        }.catch { [weak self] error in
            self?.presenter?.presentError(error)
        }
    }
}
