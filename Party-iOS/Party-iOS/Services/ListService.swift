//
//  ListService.swift
//  Party-iOS
//
//  Created by Samet on 27.02.21.
//

import Foundation

final class ListService: ServiceProtocol {
    func list(completion: @escaping ServiceCompletion<[Server]>) {
        let endPoint = API.list
        client.request(endPoint, completion: completion)
    }
}
