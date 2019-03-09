import RxSwift

final class ServersDependanciesProvider: NSObject {
    let useMock = false
    
    fileprivate var serverRepository: ServerRepository?
    fileprivate var serverService: ServerService?
    fileprivate var serversListInteractor: ServersListInteractor?
    
    static let shared = ServersDependanciesProvider()

    // Repository
    
    fileprivate func repository() -> ServerRepository {
        return serverRepository ?? setupRepository()
    }
    
    fileprivate func setupRepository() -> ServerRepository {
        serverRepository = ServerRepository(service: service())
        return serverRepository!
    }
    
    // Service
    
    fileprivate func service() -> ServerService {
        return serverService ?? setupService()
    }
    
    fileprivate func setupService() -> ServerService {
        let network = Network()
        serverService = useMock ? ServerServiceMock(network: network) : ServerService(network: network)
        return serverService!
    }
    
    // Interactor
    
    func getListInteractor() -> ServersListInteractor {
        return serversListInteractor ?? setupListInteractor()
    }

    fileprivate func setupListInteractor() -> ServersListInteractor {
        serversListInteractor = ServersListInteractor(repository: repository())
        return serversListInteractor!
    }
}
