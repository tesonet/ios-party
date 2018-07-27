//
//  AppFlowCoordinator.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit
import RxSwift

protocol PromptCoordinatingType {
    
    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]?) -> Observable<Action>
    func prompt(forError error: Error) -> Observable<()>

}

class AppFlowCoordinator: UINavigationController {

    private let networkService = TestioNetworkService()
    private var tokenProvider: LoginTokenProviding?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        UIView.appearance().tintColor = Colors.actionColor
        
        startFlow()
    }
    
    func startFlow() {
        setViewControllers([loginViewController()], animated: false)
        observeLoginTokenProvider()
    }

    private func observeLoginTokenProvider() {
        tokenProvider?.loginToken
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self ] token in
                let loadingViewController = self.loadingViewController(forToken: token)
                self.setViewControllers([loadingViewController], animated: true)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}

extension AppFlowCoordinator {
    
    func loginViewController() -> LoginViewController {
        let loginViewModel = LoginViewModel(authorizationPerformer: networkService,
                                            promptCoordinator: self)
        tokenProvider = loginViewModel
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.setupForViewModel()
        return loginViewController
    }
    
    func loadingViewController(forToken token: TestioToken) -> LoadingViewController {
        let loadingViewModel = LoadingViewModel(serverRetriever: networkService,
                                                promptCoordinator: self)
        let loadingViewController = LoadingViewController(viewModel: loadingViewModel)
        loadingViewController.setupForViewModel()
        return loadingViewController
    }
    
}

extension AppFlowCoordinator: PromptCoordinatingType {
    
    func prompt(forError error: Error) -> Observable<()> {
        let cancelTitle = NSLocalizedString("ALERT_ACKNOWLEDGE", comment: "")
        return promptFor(error.localizedDescription, cancelAction: cancelTitle, actions: nil).map { _ in }
    }
    
    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]?) -> Observable<Action> {
        return Observable.create { [unowned self] observer in
            let alertTitle = NSLocalizedString("ALERT", comment: "")
            let alertView = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })
            
            if let actions = actions {
                for action in actions {
                    alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                        observer.on(.next(action))
                    })
                }
            }
            
            self.present(alertView, animated: true, completion: nil)
            
            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
    }
    
}
