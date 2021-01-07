
import Foundation


protocol ServersPresenter: class {
    
    func presentServers(_ servers: [Server])
    func presentError(_ error: Error)
}
