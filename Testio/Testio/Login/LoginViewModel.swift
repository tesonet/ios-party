//
//  LoginViewModel.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol LoginViewModelType {
    
    var authorize: CocoaAction { get }
    
    
}

class LoginViewModel: LoginViewModelType {
    
    var authorize: CocoaAction {
        return CocoaAction(enabledIf: .just(true), workFactory: { [unowned self] in
            return self.authorizationObservable()
        })
    }
    
    private let disposeBag = DisposeBag()
    
    private let authorizationPerformer: AuthorizationPerformingType
    private let promptCoordinator: PromptCoordinating
    
    init(authorizationPerformer: AuthorizationPerformingType,
         promptCoordinator: PromptCoordinating) {
        self.authorizationPerformer = authorizationPerformer
        self.promptCoordinator = promptCoordinator
    }
    
    private func authorizationObservable() -> Observable<Void> {
        return Observable<TestioToken>.create { [unowned self] observer -> Disposable in
            self.authorizationPerformer.authenticate(user: .testUser) { result in
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
        .map { _ in }
        .catchError { [unowned self] error in
            return self.prompt(forError: error)
        }
        .take(1)
    }
    
    private func prompt(forError error: Error) -> Observable<()> {
        return promptCoordinator.promptFor(error.localizedDescription, cancelAction: "lol", actions: nil).map { _ in }
    }
    
}
