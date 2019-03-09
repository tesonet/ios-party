import RxSwift

class ServersListInteractor {
    let repository: ServerRepository
    
    init(repository: ServerRepository) {
        self.repository = repository
    }

    func request() -> Single<[Server]> {
        return repository.retrieveAllServers()
    }
}
