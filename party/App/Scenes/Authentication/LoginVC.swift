//
//  LoginVC.swift
//  party
//
//  Created by Paulius on 07/05/2020.
//  Copyright © 2020 Mediapark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback

private typealias E = LoginState.Event
private typealias Feedback = (Driver<LoginState>) -> Signal<E>
final class LoginVC: UIViewController {
    
    @IBOutlet private var bottomConstrain: NSLayoutConstraint!
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    
    private lazy var loadingVC: UIViewController = {
        let storyboard = UIStoryboard(name: "Common", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoadingVC")
      }()
    
    private lazy var enableSubmitButtonColor: UIColor = {
        return UIColor(red: 0.67, green: 0.82, blue: 0.32, alpha: 1)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        Driver.system(initialState: LoginState(),
                      reduce: LoginState.reduce,
                      feedback: general)
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    private var general: Feedback {
        return bind(self) { `self`, state in
            
            let username = self.usernameField
                .rx.text
                .map { E.typedUsername($0) }
                .asSignalOrEmpty()
            
            let password = self.passwordField
                .rx.text
                .map { E.typedPassword($0) }
                .asSignalOrEmpty()
            
            let submit = state
                .map { $0.submit }
                .filterNil()
                .flatMap { form in
                    API.Authentication.Login(loginForm: form)
                        .request()
                        .map { E.receivedSuccess($0) }
                        .asSignal(onErrorJustReturn: E.receivedError)
                }
            
            let tapLogIn = self.loginButton
                .rx.tap
                .map { _ in E.tappedLogIn }
                .asSignalOrEmpty()
            
            let buttonState = state
                .map { $0.isSubmitDisabled }
                .drive(onNext: { [weak self] isDisabled in
                    guard let self = self else { return }
                    self.loginButton.isEnabled = !isDisabled
                    self.loginButton.backgroundColor = isDisabled ? .gray : self.enableSubmitButtonColor
                })
            
            let loading = state
                .map { $0.isLoading }
                .drive(onNext: { [weak self] isLoading in
                    self?.handle(isLoading)
                })
            
            let openNext = state
                .map { $0.openMain }
                .filterNil()
                .drive(onNext: { _ in
                    UIManager.goToMainScreen()
                })

            return Bindings(subscriptions: [buttonState, loading, openNext],
                            events: [username, password, submit, tapLogIn])
        }
    }
    
    private func handle(_ loading: Bool) {
        if loading {
            addChild(self.loadingVC)
            view.addSubview(self.loadingVC.view)
            loadingVC.didMove(toParent: self)
        } else {
            loadingVC.willMove(toParent: nil)
            loadingVC.view.removeFromSuperview()
            loadingVC.removeFromParent()
        }
    }
    
    private func setupUI() {
        adjustBottom(constrain: bottomConstrain)
        dismissKeyboardOnTap()
    }
}
