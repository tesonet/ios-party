//
//  SortingOptions.swift
//  Testio
//
//  Created by Andrii Popov on 3/10/21.
//

import Foundation

enum SortingOption {
    case distance
    case alphanumerical
    
    var title: String {
        switch self {
        case .distance:
            return ServersListLocalization.sorting.distance
        case .alphanumerical:
            return ServersListLocalization.sorting.alphanumerical
        }
    }
}
