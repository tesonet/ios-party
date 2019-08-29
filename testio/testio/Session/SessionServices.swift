
import Foundation


protocol SessionServices {
    
    var auth: AuthService { get }
    var servers: ServersService { get }
}


extension AppDelegate {
    
    func createDefaultSessionServices(with sessionContext: SessionContext) -> SessionServices {
        return DefaultSessionServices(context: sessionContext)
    }
}


private class DefaultSessionServices: SessionServices {
    
    let auth: AuthService
    let servers: ServersService
    
    init(context: SessionContext) {
        auth = AuthService(sessionContext: context)
        servers = ServersService(sessionContext: context)
    }
}
