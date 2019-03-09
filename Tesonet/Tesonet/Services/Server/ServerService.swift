import RxSwift

class ServerService {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func retrieveAllServers() -> Single<[Server]> {
        return network.retrieveAllServers()
    }
}
