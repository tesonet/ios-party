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
    var credentialsConsumer: AnyObserver<(String, String)> { get }
    var initialCredentials: TestioUser? { get }
    var areCredentialsValidForSubmit: Observable<Bool> { get }

}

protocol LoginTokenProviding {
    
    var loginToken: Observable<TestioToken> { get }

}

class LoginViewModel: LoginTokenProviding, LoginViewModelType, ViewModelTaskPerformingType {

    private let disposeBag = DisposeBag()
    
    private let authorizationPerformer: AuthorizationPerformingType
    private let credentialsManager: CredentialsManaging

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
        return Action(workFactory: { [unowned self] in
            self.credentialsObservable
                .delay(0.5, scheduler: MainScheduler.instance)
                .flatMap { self.authorize(user: $0) }
        })
    }()
    
    //MARK: - Credentials

    var initialCredentials: TestioUser?
    
    let credentialsConsumingSubject = ReplaySubject<(String, String)>.create(bufferSize: 1)
    
    private var credentialsObservable: Observable<TestioUser> {
        return credentialsConsumingSubject.asObservable()
            .map { TestioUser.init(username: $0, password: $1) }
    }
    
    var credentialsConsumer: AnyObserver<(String, String)> {
        return credentialsConsumingSubject.asObserver()
    }
    
    var areCredentialsValidForSubmit: Observable<Bool> {
        return credentialsObservable
            .map { credentials in
                !credentials.username.trimmingCharacters(in: .whitespaces).isEmpty &&
                !credentials.password.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    //MARK: - Initialization
    
    init(authorizationPerformer: AuthorizationPerformingType,
         credentialsManager: CredentialsManaging) {
        self.authorizationPerformer = authorizationPerformer
        self.credentialsManager = credentialsManager
        addAuthorizeActionResultHandlers()
        resolveCredentials()
    }
    
    private func resolveCredentials() {
        guard let user = try? credentialsManager.retrieveUser() else {
            initialCredentials = nil
            return
        }
        
        initialCredentials = user
        credentialsConsumingSubject.onNext((user.username, user.password))
    }
    
    private func addAuthorizeActionResultHandlers() {
        authorize.elements
            .bind(to: loginTokenSubject.asObserver())
            .disposed(by: disposeBag)
        
        //Only store credentials to Keychain if authorization returned no errors
        authorize.elements
            .flatMap { [unowned self] _ in self.credentialsObservable }
            .flatMap { [unowned self] user in self.storeToKeychain(user: user) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    //MARK: - Authorization helpers
    
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
    
    //MARK: - Keychain reactive wrapper
    
    private func storeToKeychain(user: TestioUser) -> Observable<TestioUser> {
        return Observable<TestioUser>.create { [unowned self] observer -> Disposable in
            do {
                try self.credentialsManager.save(testioUser: user)
                observer.onNext(user)
            } catch let error {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
