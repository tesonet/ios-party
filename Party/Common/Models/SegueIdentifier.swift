//
//  SegueIdentifier.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

/// A structure for storing segue identifiers.
struct SegueIdentifier {
    var rawValue: String
}

extension SegueIdentifier {
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SegueIdentifier: Equatable {
    
    static func ==(lhs: SegueIdentifier, rhs: SegueIdentifier) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension SegueIdentifier {
    
    static let showSplashScreenViewController = SegueIdentifier("ShowSplashScreenViewController")
    static let showLoginViewController = SegueIdentifier("ShowLoginViewController")
}
