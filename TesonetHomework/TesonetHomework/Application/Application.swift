// Created by Paulius Cesekas on 02/04/2019.

import Foundation
import Domain
import NetworkPlatform
import DataPersistant

@objc final class Application: NSObject {
    // MARK: - Constants
    @objc static let shared = Application()
    
    // MARK: - Variables
    private(set) var networkUseCaseProvider: Domain.UseCaseProvider
    private(set) var dataStorage: Storing
    private(set) var rootNavigationController: UINavigationController
    private(set) var rootNavigator: RootNavigator
    private(set) var authorizationNavigator: AuthorizationNavigator
    private(set) var serversNavigator: ServersNavigator

    // MARK: - Methods -
    private override init() {
        networkUseCaseProvider = NetworkPlatform.UseCaseProvider(with: WebServiceConstants.config)
        dataStorage = RealmStorage(config: StorageConfig())
        rootNavigationController = UINavigationController()
        rootNavigator = DefaultRootNavigator(useCaseProvider: networkUseCaseProvider)
        authorizationNavigator = DefaultAuthorizationNavigator(useCaseProvider: networkUseCaseProvider)
        serversNavigator = DefaultServersNavigator(useCaseProvider: networkUseCaseProvider)
        
    }
    
    // MARK: - Configure
    func configure(in window: UIWindow) {
        window.rootViewController = rootNavigationController
    }
}
