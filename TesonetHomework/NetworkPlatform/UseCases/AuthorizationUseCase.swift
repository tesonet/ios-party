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
    
    func login(withUsername username: String, password: String) -> Observable<Login> {
        return api.login(
            withUsername: username,
            password: password)
    }
}
