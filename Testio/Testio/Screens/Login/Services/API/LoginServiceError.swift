//
//  File.swift
//  TestProject
//
//  Created by Andrii Popov on 2/25/21.
//

import Foundation

enum LoginServiceError: Error {
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

extension LoginServiceError {
    static func !=(left: LoginServiceError, right: LoginServiceError) -> Bool {
        switch (left, right) {
        case (.requestFailed, .requestFailed),
             (.dataDecodingFailed, .dataDecodingFailed):
            return false
        default:
            return true
        }
    }
}
