//
//  CarInfoServiceProtocol.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol LoginServiceProtocol {
    var apiClient: ApiClientProtocol { get }
    var isLoadingData: Bool { get }
    func logIn(username: String, password: String, completion: @escaping (Result<AuthorizationData, LoginServiceError>) -> ())
}
