import RxSwift

class LoginService {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func retrieveToken(with params: LoginData) -> Single<String> {
        return network.retrieveToken(with: params)
    }
}
