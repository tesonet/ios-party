//
//  String+classNameAsString.swift
//  Party
//
//  Created by Darius Janavicius on 17/07/2019.
//  Copyright © 2019 tesonet. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns class name as String.
    ///
    /// - Parameter object: any class.
    /// - Returns: A name of the class or empty string.
    static func classNameAsString<T>(_ object: T) -> String {
        let name = String(describing: object).components(separatedBy: ".").first ?? ""
        return name
    }
}
