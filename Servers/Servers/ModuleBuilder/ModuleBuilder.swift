//
//  Builder.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

protocol ModuleBuilderProtocol {
    var isLoggedIn: Bool { get }
    
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createServersModule(router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    private lazy var storageService: StorageService = {
        let coredataManager = CoreDataManager()
        let serverStorageManager = ServerStorageManager(coreDataManager: coredataManager)
        return StorageService(serverStorageManager: serverStorageManager)
    }()
    
    private lazy var apiManager: ApiManager = {
        let networkService = NetworkService()
        let decodableService = DecodableService()
        let keychainService = KeychainService()
        let apiManager = ApiManager(networkService: networkService, decodableService: decodableService, keychainService: keychainService)
        return apiManager
    }()
    
    var isLoggedIn: Bool {
        return apiManager.isLoggedIn()
    }
    
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        guard let loginVC = storyboard.instantiateInitialViewController() as? LoginViewController else {
            fatalError("No LoginViewController in storyboard")
        }
                
        let presenter = LoginPresenter(view: loginVC, apiManager: apiManager, router: router)
        loginVC.presenter = presenter
        return loginVC
    }
    
    func createServersModule(router: RouterProtocol) -> UIViewController {
        let storyboard = UIStoryboard(name: "Servers", bundle: Bundle.main)
        guard let serversVC = storyboard.instantiateInitialViewController() as? ServersViewController else {
            fatalError("No ServersViewController in storyboard")
        }
        
        let presenter = ServersPresenter(view: serversVC, apiManager: apiManager, router: router, storageService: storageService)
        serversVC.presenter = presenter
        return serversVC
    }
    
}
