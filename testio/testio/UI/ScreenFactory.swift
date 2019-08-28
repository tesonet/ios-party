
import UIKit


protocol ScreenFactory {
    
    func createLogin() -> LoginViewController
}


extension SessionViewController {
    
    func createScreenFactory(with sessionContext: SessionContext) -> ScreenFactory {
        return DefaultScreenFactory(sessionContext: sessionContext)
    }
}


private class DefaultScreenFactory: ScreenFactory {
    
    private let sessionContext: SessionContext

    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    func createLogin() -> LoginViewController {
        let login = LoginViewController()
        login.facade = LoginFacade(sessionContext: sessionContext)
        return login
    }
}
