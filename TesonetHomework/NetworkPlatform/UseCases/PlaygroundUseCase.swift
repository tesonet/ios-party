// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Domain
import RxSwift

final class PlaygroundUseCase: Domain.PlaygroundUseCase {
    // MARK: - Variables
    private let api: PlaygroundAPI
    
    // MARK: - Methods -
    init(api: PlaygroundAPI) {
        self.api = api
    }
    
    func servers(with login: Login) -> Observable<[Server]> {
        return api.servers(with: login)
    }
}
