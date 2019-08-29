
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
        let login = LoginViewController()
        login.facade = LoginFacade(sessionContext: sessionContext)
        return login
    }
    
    func createServers() -> ServersViewController {
        let servers = ServersViewController()
        servers.facade = ServersFacade(sessionContext: sessionContext)
        return servers
    }
}
