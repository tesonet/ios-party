
import Foundation
import PromiseKit


class ServersService {
    
    private let sessionContext: SessionContext
    private let repo = ServersRepo()
    
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    func servers() -> Promise<[Server]> {
        return firstly {
            remoteServers()
        }.recover { [unowned self] _ in
            self.localServers()
        }
    }
    
    private func remoteServers() -> Promise<[Server]> {
        return Promise { seal in
            sessionContext.requestFactory.servers()
                .validate()
                .responseJsonData(seal: seal) { [unowned self] jsonData in

                    let decoder = JSONDecoder()
                    let response = try decoder.decode([Server].self, from: jsonData)
                    self.repo.storeServers(response)
                    return response
            }
        }
    }
    
    private func localServers() -> Promise<[Server]> {
        return Promise { seal in
            repo.fetchServers { servers in
                seal.fulfill(servers)
            }
        }
    }
}
