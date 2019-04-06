//
//  ViewController.swift
//  Mobile App
//
//  Created by Justas Liola on 06/04/2019.
//  Copyright © 2019 Justin. All rights reserved.
//

import UIKit
import RxFeedback
import RxCocoa
import RxSwift

private typealias E = LoginState.Event
private typealias C = LoginState.Command
private typealias Feedback = (Driver<LoginState>) -> Signal<E>

final class LoginViewController: UIViewController {
    
    @IBOutlet private var userNameField: UITextField!
    @IBOutlet private var passWordField: UITextField!
    @IBOutlet private var loginButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Driver.system(
            initialState: LoginState(),
            reduce: LoginState.reduce,
            feedback: typedText, tappedLogin, login, showServersFeedback)
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    private var typedText: Feedback {
        return bind(self) { `self`, state in
            
            let typedUsername = self.userNameField
                .rx.text
                .filterNil()
                .map { E.typedUsername($0) }
            
            let typedPassword = self.passWordField
                .rx.text
                .filterNil()
                .map { E.typedPassword($0) }
            
            return Bindings(subscriptions: [], events: [typedUsername, typedPassword])
        }
    }
    
    private var tappedLogin: Feedback {
        return bind(self) { `self`, state in
            
            let tappedLogin = self.loginButton
                .rx.tap
                .map { E.tappedLogin }
                .asSignal(onErrorSignalWith: .empty())
            
            let loading = state
                .map { $0.isLoading }
                .drive(self.loginButton.rx.isLoading)
            
            return Bindings(subscriptions: [loading], events: [tappedLogin])
        }
    }
    
    private var login: Feedback {
        return bind(self) { `self`, state in
            
            let login = state
                .map { $0.command }
                .flatMap { command -> Driver<(String, String)> in
                    guard case .login(let userName, let password)? = command else { return .empty() }
                    return .just((userName, password))
                }
                .flatMap { loginCredentels -> Signal<E> in
                    let (userName, password) = loginCredentels
                    
                    return API.Authorization.Login(username: userName, password: password)
                        .request()
                        .map { E.receivedAuth($0) }
                        .asSignal(onErrorJustReturn: E.receivedError)
                }
            
            let storeAuth = state
                .map { $0.storeAuth }
                .filterNil()
                .drive(onNext: { auth in
                    LoginService.storeToken(auth.token)
                })
            
            return Bindings(subscriptions: [storeAuth], events: [login])
        }
    }
    
    private var showServersFeedback: Feedback {
        return bind(self) { `self`, state in
            
            let login = state
                .map { $0.command }
                .flatMap { command -> Driver<()> in
                    guard case .showServers? = command else { return .empty() }
                    return .just(())
                }
                .drive(onNext: { [unowned self] in
                    self.showServers()
                })
            
            
            return Bindings(subscriptions: [login], events: [Signal<E>]())
        }
    }
    
    private func showServers() {
        let questionnaireVC = ServersViewController.createFrom(storyboard: StoryboardNames.servers)
        
        setRootVC {
            UIApplication.topViewController()?.present(questionnaireVC, animated: false, completion: nil)
        }
    }
    
    private func setRootVC(_ animations: @escaping ()->()) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        UIView.transition(with: window,
                          duration: 0.5, options: .transitionCrossDissolve,
                          animations: animations,
                          completion: nil)
    }
}
