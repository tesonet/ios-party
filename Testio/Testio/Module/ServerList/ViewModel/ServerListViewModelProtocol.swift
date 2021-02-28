//
//  ServerListViewModelProtocol.swift
//  Testio
//
//  Created by Claus on 26.02.21.
//

import Foundation

protocol ServerListViewModelProtocol {
    var items: [ServerListServerViewModel] { get }
    func load(sortBy: ServerItemLocalRepositorySortOption)
    func logout()
}
