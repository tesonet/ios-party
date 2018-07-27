//
//  ServersViewModel.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol LoadingViewModelType {
    
    var load: Action<Void, [TestioServer]> { get }
    
}

protocol ServersResultType {
    
    var servers: Observable<[TestioServer]> { get }
    
}

class ServersViewModel: LoadingViewModelType, ServersResultType {
    
    private let serverRetriever: ServersRetrievingType
    private let promptCoordinator: PromptCoordinatingType
    private let token: TestioToken
    
    private let disposeBag = DisposeBag()

    private let serversSubject = PublishSubject<[TestioServer]>()
    
    var servers: Observable<[TestioServer]> {
        return serversSubject.asObservable()
    }
    
    lazy var load: Action<Void, [TestioServer]> = {
        return Action(workFactory: { [unowned self] _ in
            return self.servers(withToken: self.token)
        })
    }()
    
    init(token: TestioToken,
         serverRetriever: ServersRetrievingType,
         promptCoordinator: PromptCoordinatingType) {
        self.serverRetriever = serverRetriever
        self.promptCoordinator = promptCoordinator
        self.token = token

        addActionHandlers()
    }
    
    private func addActionHandlers() {
        load.errors
            .map { actionError -> Error in
                if case ActionError.underlyingError(let error) = actionError {
                    return error
                }
                return actionError
            }
            .flatMap { self.promptCoordinator.prompt(forError: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        load.elements
            .bind(to: serversSubject.asObserver())
            .disposed(by: disposeBag)
    }
    
    private func servers(withToken token: TestioToken) -> Observable<[TestioServer]> {
        return Observable<[TestioServer]>.create { [unowned self] observer -> Disposable in
            self.serverRetriever.servers(withToken: token) { result in
                switch result {
                case .success(let servers):
                    observer.onNext(servers)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
}
