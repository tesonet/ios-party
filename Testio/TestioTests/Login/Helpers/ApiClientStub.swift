//
//  ApiClientStub.swift
//  TestioTests
//
//  Created by Andrii Popov on 3/9/21.
//

import Foundation
@testable import Testio

struct ApiClientStub: ApiClientProtocol {
    let successfullyLoaded: Bool
    let loadedData: Data?
    
    init(isSuccess: Bool, loadedData: Data? = nil) {
        self.successfullyLoaded = isSuccess
        self.loadedData = loadedData
    }

    func post(url: URL, body: Data?, headers: [String : String], completion: @escaping (Result<Data, ApiClientError>) -> ()) {
        if successfullyLoaded {
            completion(.success(loadedData!))
        } else {
            completion(.failure(.requestFailed(Int.max, "Api client stub error")))
        }
    }
}
