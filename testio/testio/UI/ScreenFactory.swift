
import UIKit


protocol ScreenFactory {
    
    func createLogin() -> LoginViewController
    func createServers() -> ServersViewController
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
        let facade = LoginFacade(sessionContext: sessionContext)
        let login = LoginViewController.createWithFacade(facade)
        return login
    }
    
    func createServers() -> ServersViewController {
        let facade = ServersFacade(sessionContext: sessionContext)
        let servers = ServersViewController.createWithFacade(facade)
        return servers
    }
}
