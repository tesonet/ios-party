//
//  ServiceFactory.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import UIKit

class ServiceFactory: ServiceFactoryProtocol {
    
    lazy var secureStorageService: SecureStorageServiceProtocol = SecureStorageService()
    
    lazy var apiService: ApiServiceProtocol = ApiService(secureStorage: secureStorageService)
    
    lazy var serverItemLocalRepository: ServerItemLocalRepositoryProtocol = {
        ServerItemLocalRepository(
            container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        )
    }()
    
    lazy var configService: ConfigServiceProtocol = ConfigService()
}
