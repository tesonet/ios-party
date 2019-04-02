// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let networkProvider: NetworkProvider
    
    public init(with config: APIConfig) {
        networkProvider = NetworkProvider(with: config)
    }
    
    public func makeAuthorizationUseCase() -> Domain.AuthorizationUseCase {
        let api = networkProvider.makeAuthorizationAPI()
        return AuthorizationUseCase(api: api)
    }
    
    public func makePlaygroundUseCase() -> Domain.PlaygroundUseCase {
        let api = networkProvider.makePlaygroundAPI()
        return PlaygroundUseCase(api: api)
    }
}
