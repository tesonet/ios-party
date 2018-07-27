//
//  LoginViewModel.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol LoginViewModelType {
    
    var authorize: Action<Void, TestioToken> { get }
    var credentialsObserver: AnyObserver<(String, String)> { get }
    
}

protocol LoginTokenProviding {
    
    var loginToken: Observable<TestioToken> { get }

}

class LoginViewModel: LoginTokenProviding, LoginViewModelType, ViewModelTaskPerformingType {

    private let disposeBag = DisposeBag()
    
    private let authorizationPerformer: AuthorizationPerformingType

    //MARK: - ViewModelTaskPerformingType
    
    var taskType: TaskType = .authentication
    
    var errors: Observable<ActionError> {
        return authorize.errors
    }
    
    var executing: Observable<Bool> {
        return authorize.executing
    }
    
    //MARK: - LoginTokenProviding
    
    private var loginTokenSubject = PublishSubject<TestioToken>()
    
    var loginToken: Observable<TestioToken> {
        return loginTokenSubject.asObservable()
    }
    
    //MARK: - LoginViewModelType
    
    lazy var authorize: Action<Void, TestioToken> = {
        return Action(enabledIf: areCredentialsFilled, workFactory: { [unowned self] in
            self.credentialsSubject
                .delay(0.5, scheduler: MainScheduler.instance)
                .map { TestioUser.init(username: $0, password: $1) }
                .flatMap { self.authorize(user: $0) }
        })
    }()
    
    private var credentialsSubject = ReplaySubject<(String, String)>.create(bufferSize: 1)
    
    var credentialsObserver: AnyObserver<(String, String)> {
        return credentialsSubject.asObserver()
    }
    
    init(authorizationPerformer: AuthorizationPerformingType) {
        self.authorizationPerformer = authorizationPerformer
        addActionHandlers()
    }
    
    private func addActionHandlers() {
        authorize.elements
            .bind(to: loginTokenSubject.asObserver())
            .disposed(by: disposeBag)
    }
    
    //MARK: - Authorization helpers
    
    private var areCredentialsFilled: Observable<Bool> {
        return credentialsSubject
            .map { credentials in
                !credentials.0.trimmingCharacters(in: .whitespaces).isEmpty &&
                !credentials.1.trimmingCharacters(in: .whitespaces).isEmpty
            }
    }
    
    private func authorize(user: TestioUser) -> Observable<TestioToken> {
        return Observable<TestioToken>.create { [unowned self] observer -> Disposable in
            self.authorizationPerformer.authorize(user: user) { result in
                switch result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let token):
                    observer.onNext(token)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
}
