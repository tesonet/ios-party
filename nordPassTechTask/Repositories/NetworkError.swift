//
//  NetworkError.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 14/04/2021.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknownError
    case unathorized
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "Unknown Server Error"
        case .unathorized: return "Wrong username or password"
        }
    }
}
