import RxSwift

class ServerService {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func retrieveAll() -> Single<[Server]> {
        return network.retrieveAll()
    }
}
