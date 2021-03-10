//
//  Data+CarInfo.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol ServersListDataDecodingServiceProtocol {
    func value(from data: Data) -> Result<[Server], DataDecodingError>
}

struct ServersListDataDecodingService: ServersListDataDecodingServiceProtocol {
    
    let client: DataDecodingClient
    
    func value(from data: Data) -> Result<[Server], DataDecodingError> {
        return client.value(from: data)
    }
}



