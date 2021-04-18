//
//  Builder.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

protocol ModuleBuilderProtocol {
    func createLoginModule(router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        guard let loginVC = storyboard.instantiateInitialViewController() as? LoginViewController else {
            fatalError("No LoginViewController in storyboard")
        }
        
        let networkService = NetworkService()
        let decodableService = DecodableService()
        let keychainService = KeychainService()
        let apiManager = ApiManager(networkService: networkService, decodableService: decodableService, keychainService: keychainService)
        
        let presenter = LoginPresenter(view: loginVC, apiManager: apiManager, router: router)
        loginVC.presenter = presenter
        return loginVC
    }
}
