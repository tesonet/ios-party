//
//  AppError.swift
//  AtlasTest
//
//  Created by Irina  Shupikova on 9/29/19.
//  Copyright © 2019 krokus. All rights reserved.
//

import Foundation

enum ErrorSeverity {
    case recoverable
    case fatal
}

protocol AppError: Error  {
    var title: String { get }
    var name: String { get }
    var description: String { get }
    var severity: ErrorSeverity { get }
}

enum AppTestError: AppError {
    case success
    case unableToReadConfiguration
    case networkUnavailable
    case authError
    case service
    case errorWith(error: Error)
    case onUnauthorizedRequest(response: HTTPURLResponse)
    
    var title: String {
        switch self {
        case .success: return NSLocalizedString("Success", comment: "Success")
        case .unableToReadConfiguration,
         .networkUnavailable,
         .authError,
         .service,
         .errorWith: return NSLocalizedString("Error", comment: "Error" )
        case .onUnauthorizedRequest: return ""
        }
    }

    var name: String {
        switch self {
        case .success : return "success"
        case .unableToReadConfiguration : return "unableToReadConfiguration"
        case .networkUnavailable : return "networkUnavailable"
        case .authError : return "authError"
        case .service : return "service"        case .errorWith(let error): return error.localizedDescription
        case .onUnauthorizedRequest: return "onUnauthorizedRequest"
        }
    }

    var description: String {
        switch self {
        case .success: return NSLocalizedString("Success", comment: "Success")
        case .unableToReadConfiguration: return NSLocalizedString("Unable to read the configuration due to an error", comment: "" )
        case .networkUnavailable: return NSLocalizedString("Network is unavailable", comment: "Displayed when connection lost or unavailable")
        case .authError: return NSLocalizedString("Session is expired, please login again", comment: "Authorization error")
        case .service: return NSLocalizedString("There is some service error. Please call the service or try again later.", comment: "Services error")
        case .errorWith(let error):
            if error.localizedDescription.starts(with: "The Internet connection") {
                return NSLocalizedString("Service error. Failed to retrieve data, try again later.", comment: "Services error")
            }
            return NSLocalizedString(error.localizedDescription, comment: "Unexpected error")
        case .onUnauthorizedRequest: return "Service response error"
        }
    }

    var severity: ErrorSeverity {
        switch self {
        case .success: return .recoverable
        case .unableToReadConfiguration: return .fatal
        case .networkUnavailable: return .recoverable
        case .authError: return .recoverable
        case .service: return .recoverable
        case .errorWith: return .recoverable
        case .onUnauthorizedRequest: return .recoverable
        }
    }
}

extension AppTestError: Equatable {
    static func == (lhs: AppTestError, rhs: AppTestError) -> Bool {
        return lhs.name == rhs.name
    }
}

