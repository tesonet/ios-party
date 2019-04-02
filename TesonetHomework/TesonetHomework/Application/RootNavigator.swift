// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain

protocol RootNavigator: Navigatable {
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
        
        let navigator = Application.shared.authorizationNavigator
        if rootNavigationController.viewControllers.isEmpty {
            navigator.navigateToLogin()
        } else {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionFlipFromLeft,
                animations: {
                    navigator.navigateToLogin()
                })
        }
    }
}
