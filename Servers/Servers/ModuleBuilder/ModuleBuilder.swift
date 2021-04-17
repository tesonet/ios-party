//
//  Builder.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 14.04.2021.
//

import UIKit

protocol ModelBuilderProtocol {
    static func createLoginModule() -> UIViewController
}

class ModelBuilder: ModelBuilderProtocol {
    
    static func createLoginModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        guard let loginVC = storyboard.instantiateInitialViewController() as? LoginViewController else {
            fatalError("No LoginViewController in storyboard")
        }
        
        let networkService = NetworkService()
        let presenter = LoginPresenter(view: loginVC, networkService: networkService)

        loginVC.presenter = presenter
        return loginVC
    }
}
