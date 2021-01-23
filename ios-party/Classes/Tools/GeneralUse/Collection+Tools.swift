//
//  Collection+Tools.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import Foundation

extension Collection {
    
    // MARK: - Safe Subscript
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /// Sample: `list[safe: index]`
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
