//
//  CarInfoApiClientProtocol.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol ApiClientProtocol {
    func post(url: URL, body: Data?, headers: [String: String], completion: @escaping (Result<Data, ApiClientError>) -> ())
}
