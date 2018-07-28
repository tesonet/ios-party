//
//  AppFlowCoordinator.swift
//  Testio
//
//  Created by Mindaugas on 26/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol PromptCoordinatingType {
    
    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]?) -> Observable<Action>
    func prompt(forError error: Error) -> Observable <String>

}

class AppFlowCoordinator: UINavigationController {

    private let networkService = TestioNetworkService()
    
    private var tokenProvider: LoginTokenProviding?
    
    private var serverResultsProvider: ServerResultsProviding? {
        didSet {
            prepareToPresentServerList()
        }
    }
    
    private var currentTaskPerformer: ViewModelTaskPerformingType? {
        didSet {
            addTaskPerformerObservables()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private lazy var loadingViewController: LoadingViewController = {
        let viewController = LoadingViewController()
        viewController.loadViewIfNeeded()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        UIView.appearance().tintColor = Colors.actionColor
        
        startFlow()
    }
    
    func startFlow() {
        setViewControllers([loginStack()], animated: false)
        prepareToRetrieveServers()
    }

    //MARK: - Flow adjust helpers
    
    private func prepareToRetrieveServers() {
        let serversViewModel = ServerRetrieverViewModel(serverRetriever: networkService)
        
        tokenProvider?.loginToken
            .do(onNext: { [unowned self] _ in
                self.currentTaskPerformer = serversViewModel
                self.serverResultsProvider = serversViewModel
            })
            .subscribe(serversViewModel.load.inputs)
            .disposed(by: disposeBag)
    }
    
    private func prepareToPresentServerList() {
        
    }
    
    //MARK: - Login stack
    
    private func loginStack() -> LoginViewController {
        let loginViewModel = LoginViewModel(authorizationPerformer: networkService)
        currentTaskPerformer = loginViewModel
        tokenProvider = loginViewModel
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.setupForViewModel()
        return loginViewController
    }
    
    private func serverPresenterStack() {
        
    }
    
}

extension AppFlowCoordinator {
    
    private func addTaskPerformerObservables() {
        currentTaskPerformer?.errors
            .map { actionError -> Error in
                if case ActionError.underlyingError(let error) = actionError {
                    return error
                }
                return actionError
            }
            .flatMap { self.prompt(forError: $0) }
            .do(onNext: { [unowned self] _ in
                self.popViewController(animated: true)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        currentTaskPerformer?.executing
            .observeOn(MainScheduler.instance)
            .filter { $0 }
            .map { [unowned self] _ in self.currentTaskPerformer?.taskType }
            .do(onNext: { [unowned self] taskType in
                self.pushLoadingViewController(withMessage: taskType?.description)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func pushLoadingViewController(withMessage message: String?) {
        loadingViewController.loadingStatusText = message
        
        guard loadingViewController.parent == nil else {
            return
        }
        
        self.pushViewController(loadingViewController, animated: true)
    }

}

extension AppFlowCoordinator: PromptCoordinatingType {
    
    func prompt(forError error: Error) -> Observable<String> {
        let cancelTitle = NSLocalizedString("ALERT_ACKNOWLEDGE", comment: "")
        return promptFor(error.localizedDescription, cancelAction: cancelTitle, actions: nil)
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
