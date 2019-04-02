// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain
import RxSwift
import RxCocoa
import KeychainAccess

final class LoginViewModel: ViewModelType {
    struct Input {
        let login: Driver<LoginCredentials>
    }
    struct Output {
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    // MARK: - Variables
    private let authorizationUseCase: AuthorizationUseCase
    private let disposeBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    
    init(with useCase: AuthorizationUseCase) {
        self.authorizationUseCase = useCase
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        let login = transform(login: input.login)
        login
            .drive(onNext: { [unowned self] (login) in
                self.saveLogin(login)
                self.navigateToServerList()
            })
            .disposed(by: disposeBag)
        
        return Output(
            isLoading: activityIndicator.asDriver(),
            error: errorTracker.asDriver())
    }
    
    private func transform(login: Driver<LoginCredentials>) -> Driver<Login> {
        return login
            .flatMapLatest { [unowned self] (credentials) -> Driver<Login> in
                return self.authorizationUseCase
                    .login(with: credentials)
                    .debug()
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
    // MARK: - Helpers
    private func saveLogin(_ login: Login) {
        login.save()
    }
    
    private func navigateToServerList() {
        let navigator = Application.shared.authorizationNavigator
        navigator.navigateToServerList()
    }
}
