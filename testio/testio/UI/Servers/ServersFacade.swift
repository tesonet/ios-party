
import Foundation
import PromiseKit


class ServersFacade {
    
    private let sessionContext: SessionContext
    
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    func servers() -> Promise<[Server]> {
        return sessionContext.services.servers.servers()
    }
    
    func logout() {
        sessionContext.session.deactivate()
    }
}
