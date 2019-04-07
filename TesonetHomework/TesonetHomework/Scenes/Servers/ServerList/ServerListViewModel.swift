// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

final class ServerListViewModel: ViewModelType {
    struct Input {
        let fetchServers: Driver<Void>
        let sortServers: Driver<ServerSort>
        let logout: Driver<Void>
    }
    struct Output {
        let isLoading: Driver<Bool>
        let error: Driver<Error>
        let servers: Driver<[Server]>
    }
    
    // MARK: - Variables
    private let playgroundUseCase: PlaygroundUseCase
    private let disposeBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    
    init(with useCase: PlaygroundUseCase) {
        self.playgroundUseCase = useCase
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        let servers = transform(fetchServers: input.fetchServers)
        transform(logout: input.logout)
        return Output(
            isLoading: activityIndicator.asDriver(),
            error: errorTracker.asDriver(),
            servers: servers)
    }
    
    private func transform(fetchServers: Driver<Void>) -> Driver<[Server]> {
        return fetchServers
            .debug("fetchServers")
            .flatMapLatest { [unowned self] (_) -> Driver<[Server]> in
                guard let login = Login.load() else {
                    self.errorTracker.onError(NetworkError.unauthorized)
                    return Driver.empty()
                }
                
                return self.playgroundUseCase
                    .servers(with: login)
                    .debug("servers")
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
    private func transform(logout: Driver<Void>) {
        logout
            .drive(onNext: { [unowned self] (_) in
                self.logout()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers
    private func logout() {
        Login.remove()
        let navigator = Application.shared.rootNavigator
        navigator.navigateToLogin()
    }
}
