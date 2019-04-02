// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain
import NetworkPlatform

@objc final class Application: NSObject {
    // MARK: - Constants
    @objc static let shared = Application()
    
    // MARK: - Variables
    private(set) var networkUseCaseProvider: Domain.UseCaseProvider
    private(set) var rootNavigator: RootNavigator
    private(set) var authorizationNavigator: AuthorizationNavigator

    // MARK: - Methods -
    private override init() {
        networkUseCaseProvider = NetworkPlatform.UseCaseProvider(with: WebServiceConstants.config)
        rootNavigator = DefaultRootNavigator(useCaseProvider: networkUseCaseProvider)
        authorizationNavigator = DefaultAuthorizationNavigator(useCaseProvider: networkUseCaseProvider)
    }
}
