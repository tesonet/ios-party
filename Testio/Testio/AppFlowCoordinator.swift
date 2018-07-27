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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        UIView.appearance().tintColor = Colors.actionColor
        
        startFlow()
    }
    
    func startFlow() {
        let loginViewModel = LoginViewModel(authorizationPerformer: networkService,
                                            promptCoordinator: self)
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.setupForViewModel()
        setViewControllers([loginViewController], animated: false)
        tokenProvider = loginViewModel
        tokenProvider?.loginToken
            .map { token in
                
            }
            
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
