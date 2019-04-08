// Created by Paulius Cesekas on 01/04/2019.

import Foundation
import Domain
import RxSwift

final class AuthorizationUseCase: Domain.AuthorizationUseCase {
    // MARK: - Variables
    private let api: AuthorizationAPI
    
    // MARK: - Methods -
    init(api: AuthorizationAPI) {
        self.api = api
    }
    
    func login(with credentials: LoginCredentials) -> Observable<Login> {
        return api.login(with: credentials)
    }
}
