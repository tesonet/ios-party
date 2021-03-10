//
//  File.swift
//  TestProject
//
//  Created by Andrii Popov on 2/25/21.
//

import Foundation

enum ServersListServiceError: Error {
    case requestFailed(String)
    case dataDecodingFailed(String)
    
    var description: String {
        switch self {
        case .requestFailed(let reason),
             .dataDecodingFailed(let reason):
            return reason
        }
    }
}
