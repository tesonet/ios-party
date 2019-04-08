// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Domain
import RxSwift

class AuthorizationAPI {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    public func login(with credentials: LoginCredentials) -> Observable<Login> {
        let path = "v1/tokens"
        return network.postItem(
            path,
            parameters: credentials.toJSON(),
            headers: nil)
    }
}
