//
//  ApiServiceProtocol.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ApiServiceProtocol {
    func auth(credentials: DomainCredentials, completion: ((Result<Void, ApiServiceError>) -> ())?)
    func loadServers(completion: ((Result<[DomainServerItem], ApiServiceError>) -> ())?)
}
