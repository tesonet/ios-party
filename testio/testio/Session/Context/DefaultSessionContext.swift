
import Foundation


private class DefaultSessionContext: SessionContext {
    
    let requestFactory: RequestFactory
    var internalServices: SessionServices!
    
    var services: SessionServices {
        return internalServices
    }
    
    let session: Session
    
    
    // MARK: - Init
    init(requestFactory: RequestFactory,
         session: Session) {
        self.requestFactory = requestFactory
        self.session = session
    }
}


// MARK: - AppDelegate + createSessionContext
extension AppDelegate {
    
    func createSessionContext() -> SessionContext {
        let session = createSession()
        let requestFactory = createRequestFactory(session: session)
        let context = DefaultSessionContext(requestFactory: requestFactory,
                                            session: session)
        context.internalServices
            = createDefaultSessionServices(with: context)
        return context
    }
}
