//
//  TestioError.swift
//  Testio
//
//  Created by Mindaugas on 27/07/2018.
//  Copyright © 2018 Mindaugas Jucius. All rights reserved.
//

import Foundation

enum TestioError: Error {
    case unauthorized
    case unknown(String?)
}

extension TestioError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return NSLocalizedString("ALERT_UNAUTHORIZED", comment: "")
        case .unknown(let message):
            let defaultMessage = message ?? NSLocalizedString("ALERT_UNKNOWN", comment: "")
            return defaultMessage
        }
    }
    
}

extension TestioError {
    
    static func error(forStatusCode code: Int) -> TestioError {
        switch code {
        case 401:
            return .unauthorized
        default:
            return .unknown(nil)
        }
    }
}
