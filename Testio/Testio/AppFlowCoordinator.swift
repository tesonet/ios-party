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
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "background")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupAppearance()
    }
    
    func startFlow() {
        let viewModel = loginViewModel()
        let loginViewController = self.loginViewController(withViewModel: viewModel)
        
        // LoginViewController is always in the navigation stack in case
        // an error occurs when authorizing
        setViewControllers([loginViewController], animated: true)
        
        if let user = try? keychainWrapper.retrieveUser() {
            // Credentials are stored in keychain. Immediatelly push loading screen
            updateLoadingViewController(withMessage: viewModel.taskType.description,
                                        animated: false)
            viewModel.initialCredentialsConsumer.onNext(user)
            viewModel.authorize
                .execute((user.username, user.password))
                .subscribe()
                .disposed(by: disposeBag)
        }
        
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
    
    private func loginViewModel() -> LoginViewModel {
        let loginViewModel = LoginViewModel(authorizationPerformer: networkService,
                                            credentialsManager: keychainWrapper)
        currentTaskPerformer = loginViewModel
        tokenProvider = loginViewModel
        return loginViewModel
    }
    
    private func loginViewController(withViewModel viewModel: LoginViewController.ViewModelType) -> LoginViewController {
        let loginViewController = LoginViewController(viewModel: viewModel)
        loginViewController.setupForViewModel()
        return loginViewController
    }
    
    //MARK: - Server presenter stack
    
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

    private func setupAppearance() {
        setNavigationBarHidden(true, animated: false)
        UIView.appearance().tintColor = Colors.actionColor
        view.backgroundColor = .lightGray
        addImageView()
    }
    
    private func addImageView() {
        view.insertSubview(backgroundImageView, at: 0)
        let constraints = [backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                           backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                           backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                           backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension AppFlowCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .push:
            return AppFlowAnimator(isPresenting: true)
        case .pop:
            return AppFlowAnimator(isPresenting: false)
        case .none:
            return nil
        }
    }
    
}

extension AppFlowCoordinator {
    
    private func addTaskPerformerObservables() {
        currentTaskPerformer?.errors
            .observeOn(MainScheduler.instance)
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
    
    private func updateLoadingViewController(withMessage message: String?, animated: Bool = true) {
        loadingViewController.loadingStatusText = message
        
        guard loadingViewController.parent == nil else {
            return
        }
        
        self.pushViewController(loadingViewController, animated: animated)
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
