// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Domain
import RxSwift

class PlaygroundAPI {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    public func servers(with login: Login) -> Observable<[Server]> {
        let path = "v1/servers"
        return network.getList(
            path,
            parameters: nil,
            headers: nil)
    }
}
