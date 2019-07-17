//
//  AppError.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

/// An error that occured in application.
enum AppError: String, LocalizedError {
    
    // Generic errors.
    
    // An unexpected error.
    case unknown
    
    var localizedDescription: String {
        return "Unknown error"
    }
}
