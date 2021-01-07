
import Foundation


private class DefaultSessionServices: SessionServices {
    
    let auth: AuthService
    let servers: ServersService
    
    
    // MARK: - Init
    init(context: SessionContext) {
        auth = AuthService(sessionContext: context)
        servers = ServersService(sessionContext: context)
    }
}


// MARK: - AppDelegate + createDefaultSessionServices
extension AppDelegate {
    
    func createDefaultSessionServices(with sessionContext: SessionContext) -> SessionServices {
        return DefaultSessionServices(context: sessionContext)
    }
}
