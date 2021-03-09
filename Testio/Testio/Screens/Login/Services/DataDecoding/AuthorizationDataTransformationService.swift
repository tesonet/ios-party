//
//  Data+CarInfo.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

protocol AuthorizationDataDecodingServiceProtocol {
    func value(from data: Data) -> Result<AuthorizationData, DataDecodingError>
}

struct AuthorizationDataDecodingService: AuthorizationDataDecodingServiceProtocol {
    
    let client: DataDecodingClient
    
    func value(from data: Data) -> Result<AuthorizationData, DataDecodingError> {
        return client.value(from: data)
    }
}



