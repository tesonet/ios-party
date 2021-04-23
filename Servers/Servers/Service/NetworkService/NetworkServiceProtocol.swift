//
//  NetworkServiceProtocol.swift
//  Servers
//
//  Created by Nikita Khodzhaiev on 18.04.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func performRequest(url: URL, method: HTTPMethod, headers: [String: String], body: Data?, completion: ((Result<Data, NetworkError>) -> ())?)
}
