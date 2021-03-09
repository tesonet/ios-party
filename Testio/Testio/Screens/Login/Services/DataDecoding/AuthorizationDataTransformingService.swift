//
//  Data+CarInfo.swift
//  TestProject
//
//  Created by Andrii Popov on 2/24/21.
//

import Foundation

enum DataTransformationError: Error {
    case generic(String)
}

protocol AuthorizationDataTransformationServiceProtocol {
    func value(from data: Data) -> Result<AuthorizationData, DataTransformationError>
}

struct AuthorizationDataTransformationService: AuthorizationDataTransformationServiceProtocol {
    
    let client: DataTransformationClient
    
    func value(from data: Data) -> Result<AuthorizationData, DataTransformationError> {
        return client.value(from: data)
    }
}



