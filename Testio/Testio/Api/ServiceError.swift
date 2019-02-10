//
//  ServiceError.swift
//  Testio
//
//  Created by lbartkus on 09/02/2019.
//  Copyright © 2019 lbartkus. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noConnection(parentError: Error?)
    case cantReadJSON
    case unknownError
    case tokenExpired
    case invalidCredentails(text: String)
    case noData
    
    var message: String? {
        switch self {
        case .invalidCredentails(let text):
            return text
        default:
            return nil
        }
    }
}
