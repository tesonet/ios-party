//
//  File.swift
//  TestProject
//
//  Created by Andrii Popov on 2/25/21.
//

import Foundation

enum ApiClientError: Error {
    case requestFailed(Int, String)
    
    var description: String {
        switch self {
        case .requestFailed(let code, let reason):
            return "\(code): \(reason)"
        }
    }
}


