//
//  ServerSortType.swift
//  ios-party
//
//  Created by Ergin Bilgin on 2021-01-24.
//

import Foundation

enum ServerSortType {
    case distance
    case alphanumerical

    // MARK: - Methods
    func title() -> String {
        switch self {
        case .distance:
            return "Distance"
            
        case .alphanumerical:
            return "Alphanumerical"
        }
    }
}

