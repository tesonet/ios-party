
import Foundation
import PromiseKit


class ServersDataModel {
    
    private let sessionContext: SessionContext
    
    weak var presenter: ServersPresenter?
    
    
    // MARK: - Init
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    
    // MARK: - Public
    func fetchServers() {
        sessionContext
            .services
            .servers
            .servers()
            .done { [weak self] servers in
                self?.presenter?.presentServers(servers)
            }
            .catch { [weak self] error in
                self?.presenter?.presentError(error)
        }
    }
    
    func logout() {
        sessionContext.session.deactivate()
    }
}
