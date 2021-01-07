
import Foundation


protocol SessionContext {
    
    var requestFactory: RequestFactory { get }
    var services: SessionServices { get }
    var session: Session { get }
}
