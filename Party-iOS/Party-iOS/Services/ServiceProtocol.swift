//
//  ServiceProtocol.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

protocol ServiceProtocol {
    var client: APIClient { get }
    typealias ServiceCompletion<T> = (Result<T, APIClientError>) -> Void

}

extension ServiceProtocol {
    var client: APIClient {
        APIClient(authenticationDelegate: AuthenticationStorage.shared)
    }
}
