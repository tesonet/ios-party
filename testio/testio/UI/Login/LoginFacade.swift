
import Foundation
import PromiseKit


class LoginFacade {
    
    private let sessionContext: SessionContext
    
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    func login(with username: String,
               password: String) -> Promise<Void> {
        return sessionContext.services.auth.login(with: username,
                                                  password: password)
            .map { [unowned self] response in
                self.sessionContext.session.activate(with: response.token)
                return ()
        }
    }
}
