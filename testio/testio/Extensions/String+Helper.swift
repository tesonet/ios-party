//
//  String+Helper.swift
//  testio
//
//  Created by Edvinas Sabaliauskas on 06/12/2018.
//  Copyright © 2018 Edvinas Sabaliauskas. All rights reserved.
//

import Foundation

// MARK: - Localizable

extension String {
    
    /// Convenience method for calling `NSLocalizedString(self, comment: "")`
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - Error

extension String: Error {
    
}
