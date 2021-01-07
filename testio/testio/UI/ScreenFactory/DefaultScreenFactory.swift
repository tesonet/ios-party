
import Foundation


private class DefaultScreenFactory: ScreenFactory {
    
    private let sessionContext: SessionContext

    
    // MARK: - Init
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    
    // MARK: - ScreenFactory
    func makeLoginScreen() -> LoginViewController {
        let dataModel = LoginDataModel(sessionContext: sessionContext)
        let login = LoginViewController.make(dataModel: dataModel)
        return login
    }
    
    func makeServersScreen() -> ServersViewController {
        let dataModel = ServersDataModel(sessionContext: sessionContext)
        let servers = ServersViewController.make(dataModel: dataModel)
        return servers
    }
}


// MARK: - SessionViewController + createScreenFactory
extension SessionViewController {
    
    func makeScreenFactory(with sessionContext: SessionContext) -> ScreenFactory {
        return DefaultScreenFactory(sessionContext: sessionContext)
    }
}
