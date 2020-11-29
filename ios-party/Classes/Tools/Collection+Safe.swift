//
//  Collection+Safe.swift
//  ios-party
//
//  Created by Lukas on 11/29/20.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
