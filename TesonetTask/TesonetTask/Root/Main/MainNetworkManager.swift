//
//  MainNetworkManager.swift
//  TesonetTask
//
//  Created by Jaroslav Chaninovicz on 2020-03-19.
//  Copyright © 2020 jch. All rights reserved.
//

import UIKit

protocol MainNetworkManagerProtocol {
    func fetchServers(_ completion: @escaping (Result<[ServersResponse]>) -> Void)
}

class MainNetworkManager: BaseNetworkManager {
    func fetchServers(_ completion: @escaping (Result<[ServersResponse]>) -> Void) {
        let request = ServersRequest()

        httpHandler.make(request: request) { (result: Result<[ServersResponse]>) in
            switch result {
            case .success(let data):
                completion(Result.success(data))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
