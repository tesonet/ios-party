//
//  ServerRetrieverViewModel.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol LoadingViewModelType {
    
    var load: Action<TestioToken, [TestioServer]> { get }
    
}

protocol ServerResultsProviding {
    
    var serverResults: Observable<[TestioServer]> { get }
    
}

class ServerRetrieverViewModel: LoadingViewModelType, ServerResultsProviding, ViewModelTaskPerformingType {
    
    private let serverRetriever: ServersRetrievingType
    
    private let disposeBag = DisposeBag()

    //MARK: - ViewModelTaskPerformingType
    
    var taskType: TaskType = .serverRetrieval
    
    var errors: Observable<ActionError> {
        return load.errors
    }
    
    var executing: Observable<Bool> {
        return load.executing
    }
    
    //MARK: - ServersResultType
    
    private let serversSubject = PublishSubject<[TestioServer]>()
    
    var serverResults: Observable<[TestioServer]> {
        return serversSubject.asObservable()
    }
    
    //MARK: - LoadingViewModelType
    
    lazy var load: Action<TestioToken, [TestioServer]> = {
        return Action(workFactory: { [unowned self] token in
            return self.servers(withToken: token)
        })
    }()
    
    init(serverRetriever: ServersRetrievingType) {
        self.serverRetriever = serverRetriever
        addActionHandlers()
    }
    
    private func addActionHandlers() {
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
