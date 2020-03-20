//
//  AuthNetworkManager.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol AuthNetworkManagerProtocol: class {
    func login(_ params: Dictionary<String, Any>, completion: @escaping (Result<LoginResponse>) -> Void)
}

class AuthNetworkManager: BaseNetworkManager {
    
    func login(_ params: Dictionary<String, Any>, completion: @escaping (Result<LoginResponse>) -> Void) {
        let request = LoginRequest(with: params)

        httpHandler.make(request: request) { (result: Result<LoginResponse>) in
            switch result {
            case .success(let data):
                completion(Result.success(data))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
}
