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
    
    var authorize: CocoaAction { get }
    var credentialsObserver: AnyObserver<(String, String)> { get }
    
}

protocol LoginTokenProviding {
    
    var loginToken: Observable<TestioToken> { get }

}

class LoginViewModel: LoginTokenProviding, LoginViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let authorizationPerformer: AuthorizationPerformingType
    private let promptCoordinator: PromptCoordinatingType

    init(authorizationPerformer: AuthorizationPerformingType,
         promptCoordinator: PromptCoordinatingType) {
        self.authorizationPerformer = authorizationPerformer
        self.promptCoordinator = promptCoordinator
    }
    
    //MARK: - LoginTokenProviding

    private var loginTokenSubject = PublishSubject<TestioToken>()
    
    var loginToken: Observable<TestioToken> {
        return .empty()
    }
    
    //MARK: - LoginViewModelType
    
    var authorize: CocoaAction {
        return CocoaAction(enabledIf: areCredentialsFilled, workFactory: { [unowned self] in
            return self.authorizationWorkFactory()
        })
    }
    
    private var credentialsSubject = ReplaySubject<(String, String)>.create(bufferSize: 1)
    
    var credentialsObserver: AnyObserver<(String, String)> {
        return credentialsSubject.asObserver()
    }
    
    //MARK: - Authorization helpers
    
    private var areCredentialsFilled: Observable<Bool> {
        return credentialsSubject
            .map { credentials in
                !credentials.0.trimmingCharacters(in: .whitespaces).isEmpty &&
                !credentials.1.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    private func authorizationWorkFactory() -> Observable<Void> {
        return credentialsSubject
            .map { TestioUser.init(username: $0, password: $1) }
            .flatMap { [unowned self] user in
                return self.authorize(user: user)
            }
            .do(onNext: { [unowned self] token in
                self.loginTokenSubject.onNext(token)
            })
            .map { _ in }
            .catchError { [unowned self] error in
                return self.promptCoordinator.prompt(forError: error)
            }
            .take(1)
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
