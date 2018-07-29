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
    
    func promptFor<Action : CustomStringConvertible>(title: String?,
                                                     message: String?,
                                                     cancelAction: Action,
                                                     actions: [Action]?,
                                                     style: UIAlertControllerStyle) -> Observable<Action>
    
    func prompt(forError error: Error) -> Observable <String>

}

final class AppFlowCoordinator: UINavigationController {

    // Helper services are injected into appropriate view models
    
    private let networkService = TestioNetworkService()
    private let keychainWrapper = TestioKeychainWrapper()
    private let serverPersistence = TestioServerPersistence()
    
    // Every data task performing view model exposes
    // itself through `ViewModelTaskPerformingType` and a domain specific protocol.
    
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
    }
    
    func startFlow() {
        setViewControllers([loginStack()], animated: true)
        prepareToRetrieveServers()
    }

    //MARK: - Flow adjust helpers
    
    private func prepareToRetrieveServers() {
        let serversViewModel = ServerRetrieverViewModel(serverRetriever: networkService,
                                                        serverPersister: serverPersistence)
        
        tokenProvider?.loginToken
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.currentTaskPerformer = serversViewModel
                self.serverResultsProvider = serversViewModel
            })
            .subscribe(serversViewModel.load.inputs)
            .disposed(by: disposeBag)
    }
    
    private func prepareToPresentServerList() {
        let serverPresenterViewController = serverPresenterStack()

        serverResultsProvider?.serverResults
            .observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.pushViewController(serverPresenterViewController, animated: true)
            })
            .subscribe(serverPresenterViewController.viewModel.servers)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Login stack
    
    private func loginStack() -> LoginViewController {
        let loginViewModel = LoginViewModel(authorizationPerformer: networkService,
                                            credentialsManager: keychainWrapper)
        currentTaskPerformer = loginViewModel
        tokenProvider = loginViewModel
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.setupForViewModel()
        return loginViewController
    }
    
    private func serverPresenterStack() -> ServerPresenterViewController {
        let serverPresenterViewModel = ServerPresenterViewModel(promptCoordinator: self, logout: logout())
        let serverPresenterViewController = ServerPresenterViewController(viewModel: serverPresenterViewModel)
        serverPresenterViewController.setupForViewModel()
        return serverPresenterViewController
    }
    
    //MARK: - Logout
    
    func logout() -> CocoaAction {
        return CocoaAction(workFactory: { [unowned self] _ -> Observable<Void> in
            self.serverPersistence.deleteServers()
                .do(onCompleted: {
                    try? self.keychainWrapper.deleteCredentials()
                    self.startFlow()
                })
        })
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
                self.updateLoadingViewController(withMessage: taskType?.description)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func updateLoadingViewController(withMessage message: String?) {
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
        let alertTitle = NSLocalizedString("ALERT", comment: "")
        
        return promptFor(title: alertTitle, message: error.localizedDescription, cancelAction: cancelTitle, actions: nil)
    }
    
    func promptFor<Action : CustomStringConvertible>(title: String? = nil,
                                                     message: String? = nil,
                                                     cancelAction: Action,
                                                     actions: [Action]?,
                                                     style: UIAlertControllerStyle = .alert) -> Observable<Action> {
        return Observable.create { [unowned self] observer in
            
            let alertView = UIAlertController(title: title, message: message, preferredStyle: style)
            
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
                alertView.dismiss(animated: false, completion: nil)
            }
        }
    }
    
}
