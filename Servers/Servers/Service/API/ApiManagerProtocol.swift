//
//  ApiManagerProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 17.04.2021.
//

import Foundation

protocol ApiManagerProtocol {
    init(networkService: NetworkServiceProtocol,
                  decodableService: DecodableServiceProtocol,
                  keychainService: KeychainServiceProtocol)
    
    func login(username: String, password: String, completion: ((Result<String, Error>) -> ())?)
    func getServers(completion: ((Result<[ServerModel], Error>) -> ())?)
    func save(token: String)
    func logout()
    func isLoggedIn() -> Bool
}
