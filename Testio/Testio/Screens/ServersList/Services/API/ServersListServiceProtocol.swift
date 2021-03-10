//
//  CarInfoServiceProtocol.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol ServersListServiceProtocol {
    var apiClient: ApiClientProtocol { get }
    var isLoadingData: Bool { get }
    func servers(token: String, completion: @escaping (Result<[Server], ServersListServiceError>) -> ())
}
