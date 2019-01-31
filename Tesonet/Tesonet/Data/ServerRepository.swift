import RxSwift

class ServerRepository {
    let service: ServerService
    
    init(service: ServerService) {
        self.service = service
    }
    
    func retrieveAll() -> Single<[Server]> {
        return service.retrieveAll()
    }
}
