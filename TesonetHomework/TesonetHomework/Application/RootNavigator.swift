// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain

protocol RootNavigator {
    func navigateToLogin()
}

class DefaultRootNavigator: RootNavigator {
    // MARK: - Variables
    private let useCaseProvider: UseCaseProvider
    
    // MARK: - Methods -
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigateToLogin() {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError("`UIApplication.shared.keyWindow` must be configured")
        }
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.navigateToLogin()
            }
            return
        }
        
        let viewModel = LoginViewModel(with: useCaseProvider.makeAuthorizationUseCase())
        let viewController = LoginViewController.initialiaze(with: viewModel)
        if window.rootViewController == nil {
            window.rootViewController = viewController
        } else {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionFlipFromLeft,
                animations: {
                    window.rootViewController = viewController
                })
        }
    }
}
