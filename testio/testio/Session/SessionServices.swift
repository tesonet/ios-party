
import Foundation


protocol SessionServices {
    
    var auth: AuthService { get }
}


extension AppDelegate {
    
    func createDefaultSessionServices(with sessionContext: SessionContext) -> SessionServices {
        return DefaultSessionServices(context: sessionContext)
    }
}


private class DefaultSessionServices: SessionServices {
    
    let auth: AuthService
    
    init(context: SessionContext) {
        auth = AuthService(sessionContext: context)
    }
}
