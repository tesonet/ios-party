//
//  ServerListFetchViewModelDelegate.swift
//  Testio
//
//  Created by Claus on 27.02.21.
//

import Foundation

protocol ServerListFetchViewModelDelegate: class {
    func didStartLoading()
    func didSaveItemsSuccessfully()
    func didReceiveError(error: String)
    func didReceiveUnauthorized()
}
