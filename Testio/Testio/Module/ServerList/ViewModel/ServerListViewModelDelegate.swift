//
//  ServerListViewModelDelegate.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ServerListViewModelDelegate: class {
    func didLoadItems()
    func didReceiveError(error: String)
    func didLogout()
}
