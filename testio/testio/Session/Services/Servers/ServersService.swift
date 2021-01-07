
import Foundation
import PromiseKit


class ServersService {
    
    private let sessionContext: SessionContext
    private let repo = ServersRepo()
    
    
    // MARK: - Init
    init(sessionContext: SessionContext) {
        self.sessionContext = sessionContext
    }
    
    
    // MARK: - Public
    func servers() -> Promise<[Server]> {
        return firstly {
            remoteServers()
        }.recover { _ in
            self.localServers()
        }
    }
    
    
    // MARK: - Private
    private func remoteServers() -> Promise<[Server]> {
        return Promise { seal in
            sessionContext.requestFactory.servers()
                .validate()
                .responseJsonData(seal: seal) { [weak self] (jsonData: Data) in
                    guard let self = self else { return [] }
                    
                    let response = try TestioJSONDecoder.decoder.decode([Server].self,
                                                                        from: jsonData)
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
