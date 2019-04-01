// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Domain

final class NetworkProvider {
    // MARK: - Variables
    private let config: APIConfig
    
    // MARK: - Methods -
    public init(config: APIConfig) {
        self.config = config
    }
    
    // MARK: - Networks
    public func makeAuthorizationAPI() -> AuthorizationAPI {
        let network = Network(config: config)
        return AuthorizationAPI(network: network)
    }

    public func makePlaygroundAPI() -> PlaygroundAPI {
        let network = Network(config: config)
        return PlaygroundAPI(network: network)
    }
}
