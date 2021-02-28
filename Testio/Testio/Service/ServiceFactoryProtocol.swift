//
//  ServiceFactoryProtocol.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ServiceFactoryProtocol {
    var secureStorageService: SecureStorageServiceProtocol { get }
    var apiService: ApiServiceProtocol { get }
    var serverItemLocalRepository: ServerItemLocalRepositoryProtocol { get }
    var configService: ConfigServiceProtocol { get }
}
