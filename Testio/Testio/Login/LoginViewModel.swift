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

enum TestioLoginError: Error {
    case invalidCredentials
}

extension TestioLoginError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("ALERT_INVALID_CREDENTIALS", comment: "")
        }
    }
    
}

protocol LoginViewModelType {
    
    var authorize: Action<(String?, String?), (TestioUser, TestioToken)> { get }

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
    
    lazy var authorize: Action<(String?, String?), (TestioUser, TestioToken)> = {
        return Action(workFactory: { [unowned self] (username, password) in
            guard self.areCredentialsValidForSubmit(credentials: (username, password)) else {
                return .error(TestioLoginError.invalidCredentials)
            }
            let userToAuthorize = TestioUser.init(username: username!, password: password!)
            return self.authorize(user: userToAuthorize).map { (userToAuthorize, $0) }
        })
    }()
    
    //MARK: - Credentials

    private func areCredentialsValidForSubmit(credentials: (String?, String?)) -> Bool {
        guard let username = credentials.0, let password = credentials.1 else {
            return false
        }
        return !username.trimmingCharacters(in: .whitespaces).isEmpty &&
            !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    //MARK: - Initialization
    
    init(authorizationPerformer: AuthorizationPerformingType,
         credentialsManager: CredentialsManaging) {
        self.authorizationPerformer = authorizationPerformer
        self.credentialsManager = credentialsManager
        addAuthorizeActionResultHandlers()
    }
    
    private func addAuthorizeActionResultHandlers() {
        authorize.elements
            .map { $0.1 }
            .bind(to: loginTokenSubject.asObserver())
            .disposed(by: disposeBag)
        
        //Only store credentials to Keychain if authorization returned no errors
        authorize.elements
            .map { $0.0 }
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
