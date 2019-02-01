import RxSwift

class ServerRepository {
    let service: ServerService
    
    init(service: ServerService) {
        self.service = service
    }
    
    func retrieveAllServers() -> Single<[Server]> {
        return service.retrieveAllServers()
    }
}
