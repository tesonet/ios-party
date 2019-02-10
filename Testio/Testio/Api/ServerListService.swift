//
//  ServerListService.swift
//  Testio
//
//  Created by lbartkus on 10/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation
import Alamofire

final class ServerListService {
    typealias Servers = [Server]
    
    func fetch(completion: @escaping (Servers?, ServiceError?) -> Void) {
        Alamofire.request(ApiUrlRouter.serverList)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let servers = try decoder.decode(Servers.self, from: data)
                            completion(servers, nil)
                        } catch {
                            completion(nil, ServiceError.cantReadJSON)
                        }
                    } else {
                        completion(nil, ServiceError.unknownError)
                    }
                case .failure:
                    completion(nil, ServiceError.unknownError)
                }
        }
    }
}
