
import Foundation


protocol SessionContext {
    
    var requestFactory: RequestFactory { get }
    var services: SessionServices { get }
    var session: Session { get }
}

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


private class DefaultSessionContext: SessionContext {
    
    let requestFactory: RequestFactory
    var internalServices: SessionServices!
    
    var services: SessionServices {
        return internalServices
    }
    
    let session: Session
    
    init(requestFactory: RequestFactory,
         session: Session) {
        self.requestFactory = requestFactory
        self.session = session
    }
}
