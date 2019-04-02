// Created by Paulius Cesekas on 02/04/2019.

import UIKit
import Domain

protocol AuthorizationNavigator {
    func navigateToServerList()
}

class DefaultAuthorizationNavigator: AuthorizationNavigator {
    // MARK: - Variables
    private let useCaseProvider: UseCaseProvider
    
    // MARK: - Methods -
    init(useCaseProvider: UseCaseProvider) {
        self.useCaseProvider = useCaseProvider
    }
    
    func navigateToServerList() {
        
    }
}
