//
//  SortingServiceProtocol.swift
//  Testio
//
//  Created by Andrii Popov on 3/10/21.
//

import Foundation

protocol ServersListSortingServiceProtocol {
    func sort(_ items: [Server], by sortingOption: SortingOption) -> [Server]
}
